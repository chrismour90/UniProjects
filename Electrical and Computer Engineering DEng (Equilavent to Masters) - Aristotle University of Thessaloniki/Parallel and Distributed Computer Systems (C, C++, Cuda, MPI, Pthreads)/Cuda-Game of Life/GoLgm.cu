#include <iostream>
#include "cuda.h"
#include <stdio.h>
#include <stdlib.h>

 #define ALIVE 1
 #define DEAD 0
 #define N WX*WY
 #define BLOCK_SIZE 16
 
 // Read Table from file
 void read_from_file(int *X, char *filename, int WX, int WY){
  FILE *fp = fopen(filename, "r+");
  int size = fread(X, sizeof(int), WX*WY, fp);
  printf("elements: %d\n", size);  
  fclose(fp);
} 
 
 // Save Table in file
 void save_table(int *X, int WX, int WY){
  FILE *fp;
  char filename[20];
  sprintf(filename, "cuda_gm_table%dx%d.bin", WX, WY);
  printf("Saving table in file %s\n\n", filename);
  fp = fopen(filename, "w+");
  fwrite(X, sizeof(int), WX*WY, fp);
  fclose(fp);
}
 
 // Device function: get world array index from world coordinates
 __device__ int getId(int x, int y, int WX, int WY)
 {
 // cyclic boundary conditions:
 while(x >= WX)
 x -= WX;

 while(x < 0)
 x += WX;

 while(y >= WY)
 y -= WY;

 while(y < 0)
 y += WY;

 return x + y * WX;
 }

 // Kernel:
 __global__ void runConway(int *world, int *sites, int WX, int WY)
 {
 // get the world coordinate:
 int x = blockIdx.x * blockDim.x + threadIdx.x;
 int y = blockIdx.y * blockDim.y + threadIdx.y;

 // id in 1D array which represents the world:
 int id = getId(x, y, WX, WY);

  // determine new state by rules of Conway’s Game of Life:
 int state = world[id];
 
 // calculate number of alive neighbors:
 int aliveNeighbors = 0;

 for(int x_offset=-1; x_offset<=1; x_offset++){
	for(int y_offset=-1; y_offset<=1; y_offset++){
		if(x_offset != 0 || y_offset != 0){ // don’t count itself
			int neighborId = getId(x + x_offset, y + y_offset, WX, WY);
			aliveNeighbors += world[neighborId];
		
		}
	}
 }

 // decide about new state:
 if(state == ALIVE)
 {
 if(aliveNeighbors < 2 || aliveNeighbors > 3)
 sites[id] = DEAD;
 else
 sites[id] = ALIVE;
 }
 else // if DEAD
 {
 if(aliveNeighbors == 3)
 sites[id] = ALIVE;
 }
  __syncthreads();
 }

 // Host function (CPU Code)
 int main (int argc, char * argv[])
 {
  char *filename = argv[1];
  int WX= atoi(argv[2]);
  int WY= atoi(argv[2]); 
  cudaEvent_t start, stop;
  float elapsedTime;
  
  printf("Reading %dx%d table from file %s\n", WX, WY, filename);
  int *world = (int *)malloc(WX*WY*sizeof(int));  
  int *tempsites= (int *)malloc(WX*WY*sizeof(int));  
  
  read_from_file(world, filename, WX, WY);
 
 // input results: 10x10 middle part of the world for easy checking
  printf("---->FIRST WORLD<---- 10x10 middle part\n");
 for(int y=WY/2; y<(WY/2+10); y++){
	for(int x=WX/2; x<(WX/2+10); x++){
		std::cout<<world[x + WX*y];
	}
	std::cout<<"\n";
 }
 std::cout<<"\n";
 
  // number of steps in Conway’s Game of Life:
 int iterations = atoi(argv[3]);


 // allocate memory on CUDA device:
 int *pDevWorld; // pointer to the data on the CUDA Device
 int *pTempDevWorld; // pointer to the data on the CUDA Device
 cudaMalloc((int**)&pDevWorld, N*sizeof(int));
 cudaMalloc((int**)&pTempDevWorld, N*sizeof(int));

 // copy data to CUDA device:
 cudaMemcpy(pDevWorld, world, N*sizeof(int), cudaMemcpyHostToDevice);
 cudaMemcpy(pTempDevWorld, world, N*sizeof(int), cudaMemcpyHostToDevice);
  
 // set block and grid dimensions:
 dim3 blockSize(BLOCK_SIZE, BLOCK_SIZE, 1);
 int GridX = (int)ceil(WX/(float)BLOCK_SIZE);
 int GridY = (int)ceil(WX/(float)BLOCK_SIZE);
 dim3 gridSize(GridX, GridY, 1); 
 
 printf("Blocks= %d\n", GridX*GridY);
 printf("Threads per Block= %d\n", BLOCK_SIZE*BLOCK_SIZE);
 printf("Total Threads=Blocks*Threads per Block= %d threads\n\n", BLOCK_SIZE*BLOCK_SIZE*GridX*GridY);
 // get time of start
 cudaEventCreate(&start);
 cudaEventRecord(start,0);
 
  // run the defined number of steps:
 for(int i=0; i<iterations; i++){
 // execute kernel function on GPU:
 runConway<<<gridSize, blockSize>>>(pDevWorld, pTempDevWorld, WX, WY);

  // Swap our grids and iterate again
        tempsites = pDevWorld;
        pDevWorld = pTempDevWorld;
        pTempDevWorld = tempsites;
 }
 
 // get time of end
 cudaEventCreate(&stop);
 cudaEventRecord(stop,0);
 cudaEventSynchronize(stop);
 
 // copy data back from CUDA Device to ’data’ array:
 cudaMemcpy(world, pDevWorld, N*sizeof(int), cudaMemcpyDeviceToHost);

 // free memory on the CUDA Device:
 cudaFree(pDevWorld);
 cudaFree(pTempDevWorld);

 // output results: 10x10 middle part of the world for easy checking
 printf("---->FINAL WORLD 10x10 middle part<----\n"); 
 for(int y=WY/2; y<(WY/2+10); y++){
	for(int x=WX/2; x<(WX/2+10); x++){
		std::cout<<world[x + WX*y];
	}
	std::cout<<"\n";
 }

 std::cout<<"\n";
 
 save_table(world, WX, WY);
 
 cudaEventElapsedTime(&elapsedTime, start,stop);
 printf("Elapsed time (Global Memory) : %f ms\n" ,elapsedTime);
 
 free(world);
 return 0;
 }


#include <iostream>
#include "cuda.h"
#include <stdio.h>
#include <stdlib.h>

 #define ALIVE 1
 #define DEAD 0
 #define N WX*WY
 #define BLOCK_SIZE 16
 #define SMEM (BLOCK_SIZE+2)
 
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
  sprintf(filename, "cuda_sm_table%dx%d.bin", WX, WY);
  printf("Saving table in file %s\n\n", filename);
  fp = fopen(filename, "w+");
  fwrite(X, sizeof(int), WX*WY, fp);
  fclose(fp);
}
 
 // Device function: get world array index from world coordinates
 __device__ int getId(int x, int y, int WX, int WY)
 {
  return x + y * WX;
 }

 // Kernel:
 __global__ void runConway(int *world, int *sites, int WX, int WY )
 {
 // get the world coordinate:
 int x = blockIdx.x * blockDim.x + threadIdx.x;
 int y = blockIdx.y * blockDim.y + threadIdx.y;
 
 int id = getId(x, y, WX, WY);
 
 int i = threadIdx.y;
 int j = threadIdx.x;
   
 
  // Declare the shared memory on a per block level
  __shared__ int sgrid[SMEM*SMEM];
 
 if ((x<WX)&&(y<WY))
	sgrid[SMEM+1+j+SMEM*i] = world[id];
  
  __syncthreads();
  
 __shared__ unsigned int y_min_off,y_max_off,x_min_off,x_max_off;
  
 // load upper line
	if (threadIdx.y == 0)
	{	if (y>0)
			y_min_off = y-1;
		else
			y_min_off = WY-1;

		sgrid[j+1] = world[getId(x,y_min_off,WX,WY)];
    }
	
	__syncthreads();
	
	// load lower line
	if (i ==(BLOCK_SIZE-1))
	{	if (y < WY-1)
			y_max_off = y+1;
		else
			y_max_off = 0;

		sgrid[(SMEM*(SMEM-1)+1)+j] = world[getId(x,y_max_off,WX,WY)];	
	}
	
	__syncthreads();	
	
	// load left line
	if (j ==0)
	{	if (x>0)
			x_min_off = x-1;
		else
			x_min_off = WX-1;

		sgrid[i*SMEM+SMEM] = world[getId(x_min_off,y,WX,WY)];	
	}
	
	__syncthreads();
	
	// load rigth line
	if (j ==(BLOCK_SIZE-1))
	{	if (x < WX -1)
			x_max_off = x+1;
		else
			x_max_off = 0;

		sgrid[i*SMEM+SMEM+SMEM-1] = world[getId(x_max_off,y,WX,WY)];	
	}
		
	__syncthreads();

	if (j == 0 && i == 0)
	{ 	sgrid[0] = world[getId(x_min_off,y_min_off,WX,WY)];	
		sgrid[SMEM-1] = world[getId(x_max_off,y_min_off,WX,WY)];
		sgrid[SMEM*(SMEM-1)] = world[getId(x_min_off,y_max_off,WX,WY)];
		sgrid[SMEM*SMEM-1] = world[getId(x_max_off,y_max_off,WX,WY)];
	}

	__syncthreads();

	if ((x<WX)&&(y<WY)){
  // determine new state by rules of Conway’s Game of Life:
 int state = sgrid[j+1+(i+1)*SMEM];
 
 // calculate number of alive neighbors:
 int aliveNeighbors = 0;

 for(int x_offset=-1; x_offset<=1; x_offset++){
	for(int y_offset=-1; y_offset<=1; y_offset++){
		if(x_offset != 0 || y_offset != 0){ // don’t count itself
			aliveNeighbors += sgrid[j+1+x_offset+(i+1+y_offset)*SMEM];
		
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
 dim3 gridSize(GridX,GridY, 1); 
 
 int totalThreadNum=blockSize.x*blockSize.y*gridSize.x*gridSize.y;
 
 printf("Blocks= %d\n", gridSize.x*gridSize.y);
 printf("Threads per Block= %d\n", blockSize.x*blockSize.y);
 printf("Total Threads=Blocks*Threads per Block= %d threads\n\n", totalThreadNum);
 
 
 int dataPerThread  = N / totalThreadNum;
 printf("Data Per Thread= %d\n\n", dataPerThread);
 
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
 printf("Elapsed time (Shared Memory) : %f ms\n" ,elapsedTime);
 
 free(world);
 return 0;
 }


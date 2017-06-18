#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

 #define ALIVE 1
 #define DEAD 0
 #define N WX*WY
 
void read_from_file(int *X, char *filename, int WX, int WY);
void save_table(int *X, int WX, int WY); 
int getId(int x, int y, int WX, int WY); 
void runConway(int *world, int *sites, int WX, int WY); 

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
  sprintf(filename, "cuda_serial_table%dx%d.bin", WX, WY);
  printf("Saving table in file %s\n\n", filename);
  fp = fopen(filename, "w+");
  fwrite(X, sizeof(int), WX*WY, fp);
  fclose(fp);
}
 
 //get world array index from world coordinates
 int getId(int x, int y, int WX, int WY)
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

 //Serial Kernel:
 void runConway(int *world, int *sites, int WX, int WY)
 {
 int x,y, x_offset,y_offset;
 
 for (x=0; x<WX; x++){
	for (y=0; y<WY; y++){
 // id in 1D array which represents the world:
 int id = getId(x, y, WX, WY);

  // determine new state by rules of Conway’s Game of Life:
 int state = world[id];
 
 // calculate number of alive neighbors:
 int aliveNeighbors = 0;

 for(x_offset=-1; x_offset<=1; x_offset++){
	for(y_offset=-1; y_offset<=1; y_offset++){
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
 }
 } 
 }

 // Serial (CPU Code)
 int main (int argc, char * argv[])
 {
  char *filename = argv[1];
  int WX= atoi(argv[2]);
  int WY= atoi(argv[2]); 
  struct timeval startwtime, endwtime;
  double seq_time;
  int x,y,i;
  
  printf("Reading %dx%d table from file %s\n", WX, WY, filename);
  int *world = (int *)malloc(WX*WY*sizeof(int));  
  int *nextgen= (int *)malloc(WX*WY*sizeof(int));
  int *tempsites= (int *)malloc(WX*WY*sizeof(int));  
  
  read_from_file(world, filename, WX, WY);
 
 // input results: 10x10 middle part of the world for easy checking
  printf("---->FIRST WORLD<---- 10x10 middle part\n");
 for(y=WY/2; y<(WY/2+10); y++){
	for(x=WX/2; x<(WX/2+10); x++){
		printf("%d",world[x + WX*y]);
	}
	printf("\n");
 }
 printf("\n");
 
  // number of steps in Conway’s Game of Life:
 int iterations = atoi(argv[3]);

 // get time of start
 gettimeofday (&startwtime, NULL);
 
  // run the defined number of steps:
 for(i=0; i<iterations; i++){
 // execute kernel function on GPU:
 runConway(world, nextgen, WX, WY);

  // Swap our grids and iterate again
        tempsites = world;
        world = nextgen;
        nextgen = tempsites;
 }
 
 // get time of end
 gettimeofday (&endwtime, NULL);
 
 
 // output results: 10x10 middle part of the world for easy checking
 printf("---->FINAL WORLD 10x10 middle part<----\n"); 
 for(y=WY/2; y<(WY/2+10); y++){
	for(x=WX/2; x<(WX/2+10); x++){
		printf("%d",world[x + WX*y]);
	}
	printf("\n");
 }

 printf("\n");
 
 save_table(world, WX, WY);
 
 // time in ms
 seq_time = (double)(1000*((endwtime.tv_usec - startwtime.tv_usec)/1.0e6+endwtime.tv_sec - startwtime.tv_sec));
 
 printf("Elapsed time : %f ms\n" ,seq_time);
 
 free(world);
 free(tempsites);
 free(nextgen);
 return 0;
 
 }


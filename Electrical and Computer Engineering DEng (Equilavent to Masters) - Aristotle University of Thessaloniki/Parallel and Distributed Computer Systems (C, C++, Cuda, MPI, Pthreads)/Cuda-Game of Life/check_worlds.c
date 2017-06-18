#include <stdio.h>
#include <stdlib.h>
 
 void read_from_file(int *X, char *filename, int WX, int WY){
  FILE *fp = fopen(filename, "r+");
  int size = fread(X, sizeof(int), WX*WY, fp);
  printf("elements: %d\n", size);  
  fclose(fp);
} 

int main (int argc, char * argv[])
 {
  char *filename1 = argv[1];
  char *filename2 = argv[2];
  int WX= atoi(argv[3]);
  int WY= atoi(argv[3]); 
  
  int i;
  
 int *world1 = (int *)malloc(WX*WY*sizeof(int));  
 int *world2 = (int *)malloc(WX*WY*sizeof(int));  
  
  read_from_file(world1, filename1, WX, WY);
  read_from_file(world2, filename2, WX, WY);
  
  //check if correct
  
  int flag=0; 
  int checki;
  for (i=0; i<WX*WY; i++){
		if (world1[i]==world2[i])
			flag=1;
		else
			flag=0;
			checki=i;
			break;
			
		}	
  if (flag)
	printf("PASSED\n");
  else {
    printf("FAILED on %d\n", checki);
	printf("%d != %d\n", world1[checki],world2[checki]);
	}
 free(world1);
 free(world2);
				
 return 0;
 
 }
 
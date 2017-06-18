//Christos Mourouzi
//user id: cm16663
//canditate number: 33747
//email: cm16663@my.bristol.ac.uk


/*
** Code to implement a d2q9-bgk lattice boltzmann scheme.
** 'd2' inidates a 2-dimensional grid, and
** 'q9' indicates 9 velocities per grid cell.
** 'bgk' refers to the Bhatnagar-Gross-Krook collision step.
**
** The 'speeds' in each cell are numbered as follows:
**
** 6 2 5
**  \|/
** 3-0-1
**  /|\
** 7 4 8
**
** A 2D grid:
**
**           cols
**       --- --- ---
**      | D | E | F |
** rows  --- --- ---
**      | A | B | C |
**       --- --- ---
**
** 'unwrapped' in row major order to give a 1D array:
**
**  --- --- --- --- --- ---
** | A | B | C | D | E | F |
**  --- --- --- --- --- ---
**
** Grid indicies are:
**
**          ny
**          ^       cols(jj)
**          |  ----- ----- -----
**          | | ... | ... | etc |
**          |  ----- ----- -----
** rows(ii) | | 1,0 | 1,1 | 1,2 |
**          |  ----- ----- -----
**          | | 0,0 | 0,1 | 0,2 |
**          |  ----- ----- -----
**          ----------------------> nx
**
** Note the names of the input parameter and obstacle files
** are passed on the command line, e.g.:
**
**   d2q9-bgk.exe input.params obstacles.dat
**
** Be sure to adjust the grid dimensions in the parameter file
** if you choose a different obstacle file.
*/


#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<time.h>
#include<sys/time.h>
#include<sys/resource.h>
#include <string.h>
#include"mpi.h"

#define NSPEEDS         9
#define FINALSTATEFILE  "final_state.dat"
#define AVVELSFILE      "av_vels.dat"
#define MASTER 			0

/* struct to hold the parameter values */
typedef struct
{
  int    nx;            /* no. of cells in x-direction */
  int    ny;            /* no. of cells in y-direction */
  int    maxIters;      /* no. of iterations */
  int    reynolds_dim;  /* dimension for Reynolds number */
  float density;       /* density per link */
  float accel;         /* density redistribution */
  float omega;         /* relaxation parameter */
} t_param;

/* struct to hold the 'speed' values */
typedef struct
{
  float speeds[NSPEEDS];
} t_speed;

/*
** function prototypes
*/

/* load params, allocate memory, load obstacles & initialise fluid particle densities */
int initialise(const char* paramfile, const char* obstaclefile,
               t_param* params, t_speed** cells_ptr, t_speed** tmp_cells_ptr,
               int** obstacles_ptr, float** av_vels_ptr);
			   
int calc_ncols_from_rank(int rank, int size, int NCOLS);

/*
** The main calculation methods.
** timestep calls, in order, the functions:
** accelerate_flow(), propagate() & collision()
*/
int accelerate_flow(const t_param params, t_speed* local_cells, int* obstacles, int local_nrows, int local_ncols);
int propagate_rebound_collision(const t_param params, t_speed* local_cells, t_speed* local_tmp_cells, int* local_obstacles, int local_nrows, int local_ncols, int rank, int tot_cells, float* av_vels, int index, float* toLeft, float* toRight, float* fromLeft, float* fromRight, int left, int right );
int write_values(const t_param params, t_speed* cells, int* obstacles, float* av_vels);

/* finalise, including freeing up allocated memory */
int finalise(const t_param* params, t_speed** cells_ptr, t_speed** tmp_cells_ptr,
             int** obstacles_ptr, float** av_vels_ptr);

/* Sum all the densities in the grid.
** The total should remain constant from one timestep to the next. */
float total_density(const t_param params, t_speed* cells);

/* calculate Reynolds number */
float calc_reynolds(const t_param params, t_speed* cells, int* obstacles, float* av_vels);

/* utility functions */
void die(const char* message, const int line, const char* file);
void usage(const char* exe);

/*
** main program:
** initialise, timestep loop, finalise
*/
int main(int argc, char* argv[])
{
  char*    paramfile = NULL;    /* name of the input parameter file */
  char*    obstaclefile = NULL; /* name of a the input obstacle file */
  t_param  params;              /* struct to hold parameter values */
  t_speed* cells     = NULL;    /* grid containing fluid densities */
  t_speed* tmp_cells = NULL;    /* scratch space */
  int*     obstacles = NULL;    /* grid indicating which cells are blocked */
  float* av_vels   = NULL;     /* a record of the av. velocity computed for each timestep */
  struct timeval timstr;        /* structure to hold elapsed time */
  struct rusage ru;             /* structure to hold CPU time--system and user */
  double tic, toc;              /* floating point numbers to calculate elapsed wallclock time */
  double usrtim;                /* floating point number to record elapsed user CPU time */
  double systim;                /* floating point number to record elapsed system CPU time */
  
  MPI_Status status;
  
  int NCOLS, NROWS, rank, size, local_nrows, local_ncols, ii, jj;
    
  t_speed* local_tmp_cells = NULL; 
  t_speed* local_cells  = NULL; 
 
  int* local_obstacles = NULL;
  float* toLeft  = NULL; // send 3, 6, 7 to left
  float* toRight  = NULL; // send 1, 8, 5 to right
  float* fromLeft  = NULL; // receive 1, 8, 5 from left
  float* fromRight  = NULL; // receive 3, 6 ,7 from right  
  
  /* parse the command line */
  if (argc != 3)
  {
    usage(argv[0]);
  }
  else
  {
    paramfile = argv[1];
    obstaclefile = argv[2];
  }
    
  /* initialise our data structures and load values from file */
  initialise(paramfile, obstaclefile, &params, &cells, &tmp_cells, &obstacles, &av_vels);
   
   /* 
  ** MPI_Init returns once it has started up processes
  ** Get size of cohort and rank for this process
  */
  MPI_Init( &argc, &argv );
  MPI_Comm_size( MPI_COMM_WORLD, &size );
  MPI_Comm_rank( MPI_COMM_WORLD, &rank );
  
  /* calculate tot_cells value */
  int tot_cells=0;
  for (ii=0; ii<params.ny; ii++)
  {
	for (jj=0; jj<params.nx; jj++)
		if (!obstacles[ii*params.nx +jj])
		  tot_cells++;
  }   
  
  /* determine rows and columns of the grid */
  NROWS=params.ny;
  NCOLS=params.nx;  
  
  /* 
  ** determine local grid size
  ** each rank gets all the rows, but a subset of the number of columns
  */
  local_nrows = NROWS;
  local_ncols = calc_ncols_from_rank(rank, size, NCOLS);
  if (local_ncols < 1) {
    fprintf(stderr,"Error: too many processes:- local_ncols < 1\n");
    MPI_Abort(MPI_COMM_WORLD, EXIT_FAILURE);
  }
  
   
   /* 
  ** determine process ranks to the left and right of rank
  ** respecting periodic boundary conditions
  */
  int left = (rank == MASTER) ? (rank + size - 1) : (rank - 1);
  int right = (rank + 1) % size;	
   
   /* create local version grids of cells, tmp_cells and obstacles. also create buffers for send and receive operations */
  local_tmp_cells = (t_speed*)calloc(local_nrows * (local_ncols + 2),sizeof(t_speed) );
  local_cells = (t_speed*)calloc( local_nrows * (local_ncols + 2), sizeof(t_speed) );
  local_obstacles = (int*)calloc(local_nrows * (local_ncols + 2), sizeof(t_speed) );
  toLeft = (float*)calloc(3*local_nrows, sizeof(float) );
  toRight = (float*)calloc(3*local_nrows, sizeof(float) );
  fromLeft = (float*)calloc(3*local_nrows, sizeof(float) );
  fromRight = (float*)calloc(3*local_nrows, sizeof(float) );	
    
  /* check if there is remainder */
  int remainder= NCOLS%size;
 
  /* start index of each process*/
  int start;
  if (remainder==0)
  {
	start=rank * local_ncols; 
  }
  
  else if (rank<remainder)
  {
	start= rank * local_ncols;  
  }	
  
  else
  {
	start=(local_ncols+1)*remainder+local_ncols*(rank-remainder);   
  }
   
  /* copy from original grid to each local grid */
  for(ii=0;ii<local_nrows;ii++) 
      for(jj=0; jj<local_ncols + 2; jj++) 
	  {
	    if (jj > 0 && jj < (local_ncols + 1)) 
		{
			memcpy(&local_cells[ii * (local_ncols + 2) + jj], &cells[ii*NCOLS+jj+start-1], sizeof(t_speed)); 
			memcpy(&local_tmp_cells[ii * (local_ncols + 2) + jj], &tmp_cells[ii*NCOLS+jj+start-1], sizeof(t_speed)); 
			local_obstacles[ii * (local_ncols + 2) + jj]=obstacles[ii*NCOLS+jj+start-1];
		}
				
	  }  
	
  MPI_Barrier(MPI_COMM_WORLD); 

  /* iterate for maxIters timesteps */
  gettimeofday(&timstr, NULL);
  tic = timstr.tv_sec + (timstr.tv_usec / 1000000.0);
  
  /* swap pointer */  
  t_speed* swap;
      
  for (int tt = 0; tt < params.maxIters; tt++)
  {  
    accelerate_flow(params, local_cells, local_obstacles, local_nrows, local_ncols);
    propagate_rebound_collision(params, local_cells, local_tmp_cells, local_obstacles, local_nrows, local_ncols, rank, tot_cells, av_vels, tt, toLeft, toRight, fromLeft, fromRight, left, right);
	
    /* swap local_cells and local_tmp_cells	 pointers before new iteration starts */
	swap=local_tmp_cells;
	local_tmp_cells=local_cells;	
	local_cells=swap;
	
#ifdef DEBUG
    printf("==timestep: %d==\n", tt);
    printf("av velocity: %.12E\n", av_vels[tt]);
    printf("tot density: %.12E\n", total_density(params, cells));
#endif
  }

  gettimeofday(&timstr, NULL);
  toc = timstr.tv_sec + (timstr.tv_usec / 1000000.0);
  getrusage(RUSAGE_SELF, &ru);
  timstr = ru.ru_utime;
  usrtim = timstr.tv_sec + (timstr.tv_usec / 1000000.0);
  timstr = ru.ru_stime;
  systim = timstr.tv_sec + (timstr.tv_usec / 1000000.0);

  int pp; 
  t_speed recvwrite;
  
  
  /* each process sends its local_cells back to MASTER, and MASTER copies it to the appropriate position in initila cells arreay */
  if (remainder==0)
  {	    
	for (ii=0; ii<local_nrows; ii++)
	{	
		 for (jj=1; jj<local_ncols+1; jj++)
		 {  		  
			 if (rank==MASTER)
			{
				memcpy(&cells[ii*NCOLS+jj-1], &local_cells[ii*(local_ncols+2)+jj], sizeof(t_speed));
			
				for (pp=1; pp<size; pp++)
				{
					MPI_Recv(&recvwrite, sizeof(t_speed), MPI_BYTE, pp, 1, MPI_COMM_WORLD, &status);
					start=pp*(NCOLS/size);
					memcpy(&cells[ii*NCOLS+jj+start-1], &recvwrite, sizeof(t_speed));
				}	
			}					
			else
			{
				MPI_Ssend(&local_cells[ii*(local_ncols+2)+jj], sizeof(t_speed), MPI_BYTE, 0, 1, MPI_COMM_WORLD);	
			}
		  }
	}
  }	
 /* if there is a remainder */
 else
 {   
	for (ii=0; ii<local_nrows; ii++)
	{	
		 for (jj=1; jj<local_ncols+1; jj++)
		 {  		  
			 if (rank==MASTER)
			{
				memcpy(&cells[ii*NCOLS+jj-1], &local_cells[ii*(local_ncols+2)+jj], sizeof(t_speed));
			
				for (pp=1; pp<remainder; pp++)
				{
					MPI_Recv(&recvwrite, sizeof(t_speed), MPI_BYTE, pp, 1, MPI_COMM_WORLD, &status);
					start=pp*local_ncols;
					memcpy(&cells[ii*NCOLS+jj+start-1], &recvwrite, sizeof(t_speed));
				}	
				/* skip this iteration for rank>remainder to prevent deadlocks */				
				if (jj==local_ncols)
					continue;
					
				for (pp=remainder; pp<size; pp++)
				{
					MPI_Recv(&recvwrite, sizeof(t_speed), MPI_BYTE, pp, 1, MPI_COMM_WORLD, &status);
					start=local_ncols*remainder+(local_ncols-1)*(pp-remainder);
					memcpy(&cells[ii*NCOLS+jj+start-1], &recvwrite, sizeof(t_speed));
				}
			}					
			else 
			{
				MPI_Ssend(&local_cells[ii*(local_ncols+2)+jj], sizeof(t_speed), MPI_BYTE, 0, 1, MPI_COMM_WORLD);	
			}
		  }
	} 
		
 }
 
  
   /* free up allocated memory */
  free(local_tmp_cells);
  free(local_cells);
  free(local_obstacles);
  free(toLeft);
  free(toRight);
  free(fromLeft);
  free(fromRight);
  
  /* MASTER rank is responsible to write the final results and print out the execution time*/
  if (rank==MASTER)
  {	  
	printf("==done==\n");
	printf("Reynolds number:\t\t%.12E\n", calc_reynolds(params, cells, obstacles, av_vels));
	printf("Elapsed time:\t\t\t%.6lf (s)\n", toc - tic);
	printf("Elapsed user CPU time:\t\t%.6lf (s)\n", usrtim);
	printf("Elapsed system CPU time:\t%.6lf (s)\n", systim);
	write_values(params, cells, obstacles, av_vels);
	finalise(&params, &cells, &tmp_cells, &obstacles, &av_vels);

  }
  
   MPI_Finalize();
   
  return EXIT_SUCCESS;
}

int accelerate_flow(const t_param params, t_speed* local_cells, int* local_obstacles, int local_nrows, int local_ncols)
{ 
  /* compute weighting factors */
  float w1 = params.density * params.accel / 9.0;
  float w2 = params.density * params.accel / 36.0;

  /* modify the 2nd row of the grid */
  int ii = local_nrows - 2;


  for (int jj = 1; jj < local_ncols+1; jj++)
  {
    /* if the cell is not occupied and
    ** we don't send a negative density */
    if (!local_obstacles[ii * (local_ncols+2) + jj]
        && (local_cells[ii * (local_ncols+2) + jj].speeds[3] - w1) > 0.0
        && (local_cells[ii * (local_ncols+2) + jj].speeds[6] - w2) > 0.0
        && (local_cells[ii * (local_ncols+2) + jj].speeds[7] - w2) > 0.0)
    {
      /* increase 'east-side' densities */
      local_cells[ii * (local_ncols+2) + jj].speeds[1] += w1;
      local_cells[ii * (local_ncols+2) + jj].speeds[5] += w2;
      local_cells[ii * (local_ncols+2) + jj].speeds[8] += w2;
      /* decrease 'west-side' densities */
      local_cells[ii * (local_ncols+2) + jj].speeds[3] -= w1;
      local_cells[ii * (local_ncols+2) + jj].speeds[6] -= w2;
      local_cells[ii * (local_ncols+2) + jj].speeds[7] -= w2;
    }
	
	
  }

  return EXIT_SUCCESS;
}



int propagate_rebound_collision(const t_param params, t_speed* local_cells, t_speed* local_tmp_cells, int* local_obstacles, int local_nrows, int local_ncols, int rank, int tot_cells, float* av_vels, int index, float* toLeft, float* toRight, float* fromLeft, float* fromRight, int left, int right )
{
  const float c_sq = 1.0 / 3.0; /* square of speed of sound */
  const float w0 = 4.0 / 9.0;  /* weighting factor */
  const float w1 = 1.0 / 9.0;  /* weighting factor */
  const float w2 = 1.0 / 36.0; /* weighting factor */

  /* compute all the intensive float precisions and store them in const variables*/
  const float const1 = 1 / c_sq , const2 = 1 / (2.0 * c_sq) , const3 = 1 / (2.0 * c_sq * c_sq) ;
  
  int ii, jj;
  float tot_u = 0.0; //  each mpi process' tot_u
  
  MPI_Status status;
  MPI_Request request, request2, request3, request4;
  
 	
   /* copy the appropriate speeds into left and right buffers */
  for(ii=0; ii < local_nrows; ii++)
  {
	toLeft[3*ii]= local_cells[ii * (local_ncols + 2) + 1].speeds[3];
	toLeft[3*ii+1]= local_cells[ii * (local_ncols + 2) + 1].speeds[6];
	toLeft[3*ii+2]= local_cells[ii * (local_ncols + 2) + 1].speeds[7];
  }
		
 for(ii=0; ii < local_nrows; ii++)
 {
	toRight[3*ii]=local_cells[ii * (local_ncols + 2) + local_ncols].speeds[1];
	toRight[3*ii+1]=local_cells[ii * (local_ncols + 2) + local_ncols].speeds[5];
	toRight[3*ii+2]=local_cells[ii * (local_ncols + 2) + local_ncols].speeds[8];   
 }

	/* send to the right receive from the left */

	MPI_Irecv(fromLeft,3*local_nrows, MPI_FLOAT, left, 1, MPI_COMM_WORLD, &request);
    MPI_Isend(toRight, 3*local_nrows, MPI_FLOAT, right, 1, MPI_COMM_WORLD, &request2);
	
	/* send to the left receive from the right */
	MPI_Irecv(fromRight,3*local_nrows, MPI_FLOAT, right, 2, MPI_COMM_WORLD, &request3);
    MPI_Isend(toLeft, 3*local_nrows, MPI_FLOAT, left, 2, MPI_COMM_WORLD, &request4);

	
  /* loop over the cells in the grid except second and penultimate column
  ** NB the collision step is called after
  ** the propagate step and so values of interest
  ** are in the scratch-space grid */
  
  /* create a temporary array to store the speeds so we can combine propagate and rebound, collision step in one loop */
  float tmp[NSPEEDS];
  
  for (ii = 0; ii < local_nrows; ii++)	  
  { 
	int y_n = ii + 1;	
	
	if (ii+1==local_nrows){
		y_n=0;
	}
		
	int y_s = ii - 1;  	 

    if (ii==0){
		y_s = ii + local_nrows - 1;
	}	
	  
	for (jj=2; jj < local_ncols; jj++)
	{
      /* propagation step */

	  int x_e = jj+1; // right column
	  int x_w = jj-1; // left column  
      /* propagate densities to neighbouring cells, following
      ** appropriate directions of travel and writing into
      ** scratch space grid */
      tmp[0]  = local_cells[ii * (local_ncols+2) + jj].speeds[0]; /* central cell, no movement */
      tmp[1] = local_cells[ii * (local_ncols+2) + x_w].speeds[1]; /* east */
      tmp[2]  = local_cells[y_s * (local_ncols+2) + jj].speeds[2]; /* north */
      tmp[3] = local_cells[ii * (local_ncols+2) + x_e].speeds[3]; /* west */
      tmp[4]  = local_cells[y_n * (local_ncols+2) + jj].speeds[4]; /* south */
      tmp[5] = local_cells[y_s * (local_ncols+2) + x_w].speeds[5]; /* north-east */
      tmp[6] = local_cells[y_s * (local_ncols+2) + x_e].speeds[6]; /* north-west */
      tmp[7] = local_cells[y_n * (local_ncols+2) + x_e].speeds[7]; /* south-west */
      tmp[8] = local_cells[y_n * (local_ncols+2) + x_w].speeds[8]; /* south-east */
     

	  /* if the cell contains an obstacle then rebound */	  
      if (local_obstacles[ii * (local_ncols+2) +jj])
      {
        /* called after propagate, so taking values from scratch space
        ** mirroring, and writing into main grid */
        local_tmp_cells[ii * (local_ncols+2) +jj].speeds[1] = tmp[3];
        local_tmp_cells[ii * (local_ncols+2) +jj].speeds[2] = tmp[4];
        local_tmp_cells[ii * (local_ncols+2) +jj].speeds[3] = tmp[1];
        local_tmp_cells[ii * (local_ncols+2) +jj].speeds[4] = tmp[2];
        local_tmp_cells[ii * (local_ncols+2) +jj].speeds[5] = tmp[7];
        local_tmp_cells[ii * (local_ncols+2) +jj].speeds[6] = tmp[8];
        local_tmp_cells[ii * (local_ncols+2) +jj].speeds[7] = tmp[5];
        local_tmp_cells[ii * (local_ncols+2) +jj].speeds[8] = tmp[6];
      }

	  /* don't consider occupied cells (if the cell does not contain an obstacle then collide) */
      else  if (!local_obstacles[ii * (local_ncols+2) +jj])
      {
        /* compute local density total */
        float local_density = 0.0;

        for (int kk = 0; kk < NSPEEDS; kk++)
        {
          local_density += tmp[kk];
        }
		
		/*compute the inverse of local density*/
		float loc1= 1 / local_density;

        /* compute x velocity component */
        float u_x = (tmp[1]
                      + tmp[5]
                      + tmp[8]
                      - (tmp[3]
                         + tmp[6]
                         + tmp[7]))
                     * loc1;
					 
        /* compute y velocity component */
        float u_y = (tmp[2]
                      + tmp[5]
                      + tmp[6]
                      - (tmp[4]
                         + tmp[7]
                         + tmp[8]))
                     *loc1;
					 		
        /* velocity squared */
        float u_sq = pow(u_x,2) + pow(u_y,2);

				
        /* directional velocity components */
        float u[NSPEEDS];
        u[1] =   u_x;        /* east */
        u[2] =         u_y;  /* north */
        u[3] = - u_x;        /* west */
        u[4] =       - u_y;  /* south */
        u[5] =   u_x + u_y;  /* north-east */
        u[6] = - u_x + u_y;  /* north-west */
        u[7] = - u_x - u_y;  /* south-west */
        u[8] =   u_x - u_y;  /* south-east */

        /* equilibrium densities, weights and u_sq1 coefficient */
        float d_equ[NSPEEDS], w11=w1 * local_density, w22= w2 * local_density, u_sq1= 1.0 - u_sq*const2;
		
		/* zero velocity density: weight w0 */
        d_equ[0] = w0 * local_density * (u_sq1);
        /* axis speeds: weight w1 */
		d_equ[1] = w11 * (u[1]*const1 + pow(u[1],2)*const3 + u_sq1);
        d_equ[2] = w11 * (u[2]*const1 + pow(u[2],2)*const3 + u_sq1);
        d_equ[3] = w11 * (u[3]*const1 + pow(u[3],2)*const3 + u_sq1);
        d_equ[4] = w11 * (u[4]*const1 + pow(u[4],2)*const3 + u_sq1);
        /* diagonal speeds: weight w2 */
        d_equ[5] = w22 * (u[5]*const1 + pow(u[5],2)*const3 + u_sq1);
        d_equ[6] = w22 * (u[6]*const1 + pow(u[6],2)*const3 + u_sq1);
        d_equ[7] = w22 * (u[7]*const1 + pow(u[7],2)*const3 + u_sq1);
        d_equ[8] = w22 * (u[8]*const1 + pow(u[8],2)*const3 + u_sq1);

        /* relaxation step */
        for (int kk = 0; kk < NSPEEDS; kk++)
        {		  	
          local_tmp_cells[ii * (local_ncols+2) +jj].speeds[kk] = tmp[kk] + params.omega * (d_equ[kk] - tmp[kk]);
        }
		
		/* accumulate the norm of x- and y- velocity components */
		tot_u+=sqrt((u_sq));
		
       }
     
	}
	
   }

    /* check if the message was receive */ 
    MPI_Wait(&request, &status);
    MPI_Wait(&request2, &status);
    MPI_Wait(&request3, &status);
    MPI_Wait(&request4, &status);
	
	/* copy to the last column of local cells  grid what you got from the right */	 
    for(ii=0; ii < local_nrows; ii++)
    {
	  local_cells[ii * (local_ncols + 2) + local_ncols +1].speeds[3]=fromRight[3*ii]   ;
      local_cells[ii * (local_ncols + 2) + local_ncols +1].speeds[6]=fromRight[3*ii+1] ;
	  local_cells[ii * (local_ncols + 2) + local_ncols +1].speeds[7]=fromRight[3*ii+2] ;  
    }
	 
	/* copy to the frist column of local grid what you got from the left */		 
	for(ii=0; ii < local_nrows; ii++)
	{	  
	  local_cells[ii * (local_ncols + 2)].speeds[1]=fromLeft[3*ii]   ;
      local_cells[ii * (local_ncols + 2)].speeds[5]=fromLeft[3*ii+1] ;
	  local_cells[ii * (local_ncols + 2)].speeds[8]=fromLeft[3*ii+2] ;
	}
	 
	/* do all the steps for the second column of the local grid */
    for (ii =0; ii<local_nrows; ii++)	 
	{
	  int y_n = ii + 1;	
	
	  if (ii+1==local_nrows){
		y_n=0;
	  }
		
	  int y_s = ii - 1;  	 

      if (ii==0){
		y_s = ii + local_nrows - 1;
	  }	 	 
	
	  int x_e = 1;
	  int x_w = -1;	  
      /* propagate densities to neighbouring cells, following
      ** appropriate directions of travel and writing into
      ** scratch space grid */
      tmp[0]  = local_cells[ii * (local_ncols+2) + 1].speeds[0]; /* central cell, no movement */
      tmp[1] = local_cells[ii * (local_ncols+2) +1+ x_w].speeds[1]; /* east */
      tmp[2]  = local_cells[y_s * (local_ncols+2) + 1].speeds[2]; /* north */
      tmp[3] = local_cells[ii * (local_ncols+2) +1+ x_e].speeds[3]; /* west */
      tmp[4]  = local_cells[y_n * (local_ncols+2) + 1].speeds[4]; /* south */
      tmp[5] = local_cells[y_s * (local_ncols+2) +1+ x_w].speeds[5]; /* north-east */
      tmp[6] = local_cells[y_s * (local_ncols+2) +1+ x_e].speeds[6]; /* north-west */
      tmp[7] = local_cells[y_n * (local_ncols+2) +1+ x_e].speeds[7]; /* south-west */
      tmp[8] = local_cells[y_n * (local_ncols+2) +1+ x_w].speeds[8]; /* south-east */
	  
      /* if the cell contains an obstacle then rebound */	  
      if (local_obstacles[ii * (local_ncols+2) +1])
      {
        /* called after propagate, so taking values from scratch space
        ** mirroring, and writing into main grid */
        local_tmp_cells[ii * (local_ncols+2) +1].speeds[1] = tmp[3];
        local_tmp_cells[ii * (local_ncols+2) +1].speeds[2] = tmp[4];
        local_tmp_cells[ii * (local_ncols+2) +1].speeds[3] = tmp[1];
        local_tmp_cells[ii * (local_ncols+2) +1].speeds[4] = tmp[2];
        local_tmp_cells[ii * (local_ncols+2) +1].speeds[5] = tmp[7];
        local_tmp_cells[ii * (local_ncols+2) +1].speeds[6] = tmp[8];
        local_tmp_cells[ii * (local_ncols+2) +1].speeds[7] = tmp[5];
        local_tmp_cells[ii * (local_ncols+2) +1].speeds[8] = tmp[6];
      }

	  /* don't consider occupied cells (if the cell does not contain an obstacle then collide */
      else  if (!local_obstacles[ii * (local_ncols+2) +1])
      {
        /* compute local density total */
        float local_density = 0.0;

        for (int kk = 0; kk < NSPEEDS; kk++)
        {
          local_density += tmp[kk];
        }
		
		/*compute the inverse of local density*/
		float loc1= 1 / local_density;

        /* compute x velocity component */
        float u_x = (tmp[1]
                      + tmp[5]
                      + tmp[8]
                      - (tmp[3]
                         + tmp[6]
                         + tmp[7]))
                     * loc1;
					 
        /* compute y velocity component */
        float u_y = (tmp[2]
                      + tmp[5]
                      + tmp[6]
                      - (tmp[4]
                         + tmp[7]
                         + tmp[8]))
                     *loc1;
					 		
        /* velocity squared */
        float u_sq = pow(u_x,2) + pow(u_y,2);

				
        /* directional velocity components */
        float u[NSPEEDS];
        u[1] =   u_x;        /* east */
        u[2] =         u_y;  /* north */
        u[3] = - u_x;        /* west */
        u[4] =       - u_y;  /* south */
        u[5] =   u_x + u_y;  /* north-east */
        u[6] = - u_x + u_y;  /* north-west */
        u[7] = - u_x - u_y;  /* south-west */
        u[8] =   u_x - u_y;  /* south-east */

        /* equilibrium densities, weights and u_sq1 coefficient */
        float d_equ[NSPEEDS], w11=w1 * local_density, w22= w2 * local_density, u_sq1= 1.0 - u_sq*const2;
		
		/* zero velocity density: weight w0 */
        d_equ[0] = w0 * local_density * (u_sq1);
        /* axis speeds: weight w1 */
		d_equ[1] = w11 * (u[1]*const1 + pow(u[1],2)*const3 + u_sq1);
        d_equ[2] = w11 * (u[2]*const1 + pow(u[2],2)*const3 + u_sq1);
        d_equ[3] = w11 * (u[3]*const1 + pow(u[3],2)*const3 + u_sq1);
        d_equ[4] = w11 * (u[4]*const1 + pow(u[4],2)*const3 + u_sq1);
        /* diagonal speeds: weight w2 */
        d_equ[5] = w22 * (u[5]*const1 + pow(u[5],2)*const3 + u_sq1);
        d_equ[6] = w22 * (u[6]*const1 + pow(u[6],2)*const3 + u_sq1);
        d_equ[7] = w22 * (u[7]*const1 + pow(u[7],2)*const3 + u_sq1);
        d_equ[8] = w22 * (u[8]*const1 + pow(u[8],2)*const3 + u_sq1);

        /* relaxation step */
        for (int kk = 0; kk < NSPEEDS; kk++)
        {		  	
          local_tmp_cells[ii * (local_ncols+2) +1].speeds[kk] = tmp[kk] + params.omega * (d_equ[kk] - tmp[kk]);
        }
		
		/* accumulate the norm of x- and y- velocity components */
		tot_u+=sqrt((u_sq));
		
	  }
	}
	
	  /* do all the steps for the penultimate column of the local grid */
	 for (ii =0; ii < local_nrows; ii++)	 
	 {
	  int y_n = ii + 1;	
	
	  if (ii+1==local_nrows){
		y_n=0;
	  }
		
	  int y_s = ii - 1;  	 

      if (ii==0){
		y_s = ii + local_nrows - 1;
	  }		 
	
	  int x_e = 1;
	  int x_w = -1;	  
      /* propagate densities to neighbouring cells, following
      ** appropriate directions of travel and writing into
      ** scratch space grid */
      tmp[0]  = local_cells[ii * (local_ncols + 2) + local_ncols].speeds[0]; /* central cell, no movement */
      tmp[1] = local_cells[ii * (local_ncols + 2) + local_ncols + x_w].speeds[1]; /* east */
      tmp[2]  = local_cells[y_s * (local_ncols+2) + local_ncols].speeds[2]; /* north */
      tmp[3] = local_cells[ii * (local_ncols+2) + local_ncols +x_e].speeds[3]; /* west */
      tmp[4]  = local_cells[y_n * (local_ncols+2) + local_ncols].speeds[4]; /* south */
      tmp[5] = local_cells[y_s * (local_ncols+2) + local_ncols + x_w].speeds[5]; /* north-east */
      tmp[6] = local_cells[y_s * (local_ncols+2) + local_ncols+ x_e].speeds[6]; /* north-west */
      tmp[7] = local_cells[y_n * (local_ncols+2) + local_ncols+  x_e].speeds[7]; /* south-west */
      tmp[8] = local_cells[y_n * (local_ncols+2) + local_ncols+ x_w].speeds[8]; /* south-east */
      /* if the cell contains an obstacle then rebound */
	  
	  
      if (local_obstacles[ii * (local_ncols + 2) + local_ncols])
      {
        /* called after propagate, so taking values from scratch space
        ** mirroring, and writing into main grid */
        local_tmp_cells[ii * (local_ncols + 2) + local_ncols].speeds[1] = tmp[3];
        local_tmp_cells[ii * (local_ncols + 2) + local_ncols].speeds[2] = tmp[4];
        local_tmp_cells[ii * (local_ncols + 2) + local_ncols].speeds[3] = tmp[1];
        local_tmp_cells[ii * (local_ncols + 2) + local_ncols].speeds[4] = tmp[2];
        local_tmp_cells[ii * (local_ncols + 2) + local_ncols].speeds[5] = tmp[7];
        local_tmp_cells[ii * (local_ncols + 2) + local_ncols].speeds[6] = tmp[8];
        local_tmp_cells[ii * (local_ncols + 2) + local_ncols].speeds[7] = tmp[5];
        local_tmp_cells[ii * (local_ncols + 2) + local_ncols].speeds[8] = tmp[6];
      }

	  /* don't consider occupied cells (if the cell does not contain an obstacle then collide */
      else  if (!local_obstacles[ii * (local_ncols + 2) + local_ncols])
      {
        /* compute local density total */
        float local_density = 0.0;

        for (int kk = 0; kk < NSPEEDS; kk++)
        {
          local_density += tmp[kk];
        }
		
		/*compute the inverse of local density*/
		float loc1= 1 / local_density;

        /* compute x velocity component */
        float u_x = (tmp[1]
                      + tmp[5]
                      + tmp[8]
                      - (tmp[3]
                         + tmp[6]
                         + tmp[7]))
                     * loc1;
					 
        /* compute y velocity component */
        float u_y = (tmp[2]
                      + tmp[5]
                      + tmp[6]
                      - (tmp[4]
                         + tmp[7]
                         + tmp[8]))
                     *loc1;
					 		
        /* velocity squared */
        float u_sq = pow(u_x,2) + pow(u_y,2);

				
        /* directional velocity components */
        float u[NSPEEDS];
        u[1] =   u_x;        /* east */
        u[2] =         u_y;  /* north */
        u[3] = - u_x;        /* west */
        u[4] =       - u_y;  /* south */
        u[5] =   u_x + u_y;  /* north-east */
        u[6] = - u_x + u_y;  /* north-west */
        u[7] = - u_x - u_y;  /* south-west */
        u[8] =   u_x - u_y;  /* south-east */

        /* equilibrium densities, weights and u_sq1 coefficient */
        float d_equ[NSPEEDS], w11=w1 * local_density, w22= w2 * local_density, u_sq1= 1.0 - u_sq*const2;
		
		/* zero velocity density: weight w0 */
        d_equ[0] = w0 * local_density * (u_sq1);
        /* axis speeds: weight w1 */
		d_equ[1] = w11 * (u[1]*const1 + pow(u[1],2)*const3 + u_sq1);
        d_equ[2] = w11 * (u[2]*const1 + pow(u[2],2)*const3 + u_sq1);
        d_equ[3] = w11 * (u[3]*const1 + pow(u[3],2)*const3 + u_sq1);
        d_equ[4] = w11 * (u[4]*const1 + pow(u[4],2)*const3 + u_sq1);
        /* diagonal speeds: weight w2 */
        d_equ[5] = w22 * (u[5]*const1 + pow(u[5],2)*const3 + u_sq1);
        d_equ[6] = w22 * (u[6]*const1 + pow(u[6],2)*const3 + u_sq1);
        d_equ[7] = w22 * (u[7]*const1 + pow(u[7],2)*const3 + u_sq1);
        d_equ[8] = w22 * (u[8]*const1 + pow(u[8],2)*const3 + u_sq1);

        /* relaxation step */
        for (int kk = 0; kk < NSPEEDS; kk++)
        {		  	
          local_tmp_cells[ii * (local_ncols + 2) + local_ncols].speeds[kk] = tmp[kk] + params.omega * (d_equ[kk] - tmp[kk]);
        }
		
		/* accumulate the norm of x- and y- velocity components */
		tot_u+=sqrt((u_sq));
	  }
	}	
	
	/* MASTER receives all tot_u values from everyone summed and calculates and stores the average velocity */
    float total_u = 0.0;
    MPI_Reduce(&tot_u, &total_u, 1, MPI_FLOAT, MPI_SUM, 0, MPI_COMM_WORLD);
	
	 if(rank == 0) {
        av_vels[index] = total_u / (float)tot_cells;
    }
	  
  return EXIT_SUCCESS;
}

int initialise(const char* paramfile, const char* obstaclefile,
               t_param* params, t_speed** cells_ptr, t_speed** tmp_cells_ptr,
               int** obstacles_ptr, float** av_vels_ptr)
{
  char   message[1024];  /* message buffer */
  FILE*   fp;            /* file pointer */
  int    xx, yy;         /* generic array indices */
  int    blocked;        /* indicates whether a cell is blocked by an obstacle */
  int    retval;         /* to hold return value for checking */

  /* open the parameter file */
  fp = fopen(paramfile, "r");

  if (fp == NULL)
  {
    sprintf(message, "could not open input parameter file: %s", paramfile);
    die(message, __LINE__, __FILE__);
  }

  /* read in the parameter values */
  retval = fscanf(fp, "%d\n", &(params->nx));

  if (retval != 1) die("could not read param file: nx", __LINE__, __FILE__);

  retval = fscanf(fp, "%d\n", &(params->ny));

  if (retval != 1) die("could not read param file: ny", __LINE__, __FILE__);

  retval = fscanf(fp, "%d\n", &(params->maxIters));

  if (retval != 1) die("could not read param file: maxIters", __LINE__, __FILE__);

  retval = fscanf(fp, "%d\n", &(params->reynolds_dim));

  if (retval != 1) die("could not read param file: reynolds_dim", __LINE__, __FILE__);

  retval = fscanf(fp, "%f\n", &(params->density));

  if (retval != 1) die("could not read param file: density", __LINE__, __FILE__);

  retval = fscanf(fp, "%f\n", &(params->accel));

  if (retval != 1) die("could not read param file: accel", __LINE__, __FILE__);

  retval = fscanf(fp, "%f\n", &(params->omega));

  if (retval != 1) die("could not read param file: omega", __LINE__, __FILE__);

  /* and close up the file */
  fclose(fp);

  /*
  ** Allocate memory.
  **
  ** Remember C is pass-by-value, so we need to
  ** pass pointers into the initialise function.
  **
  ** NB we are allocating a 1D array, so that the
  ** memory will be contiguous.  We still want to
  ** index this memory as if it were a (row major
  ** ordered) 2D array, however.  We will perform
  ** some arithmetic using the row and column
  ** coordinates, inside the square brackets, when
  ** we want to access elements of this array.
  **
  ** Note also that we are using a structure to
  ** hold an array of 'speeds'.  We will allocate
  ** a 1D array of these structs.
  */

  /* main grid */
  *cells_ptr = (t_speed*)malloc(sizeof(t_speed) * (params->ny * params->nx));

  if (*cells_ptr == NULL) die("cannot allocate memory for cells", __LINE__, __FILE__);

  /* 'helper' grid, used as scratch space */
  *tmp_cells_ptr = (t_speed*)malloc(sizeof(t_speed) * (params->ny * params->nx));

  if (*tmp_cells_ptr == NULL) die("cannot allocate memory for tmp_cells", __LINE__, __FILE__);

  /* the map of obstacles */
  *obstacles_ptr = malloc(sizeof(int) * (params->ny * params->nx));

  if (*obstacles_ptr == NULL) die("cannot allocate column memory for obstacles", __LINE__, __FILE__);

  /* initialise densities */
  float w0 = params->density * 4.0 / 9.0;
  float w1 = params->density      / 9.0;
  float w2 = params->density      / 36.0;

  for (int ii = 0; ii < params->ny; ii++)
  {
    for (int jj = 0; jj < params->nx; jj++)
    {
      /* centre */
      (*cells_ptr)[ii * params->nx + jj].speeds[0] = w0;
      /* axis directions */
      (*cells_ptr)[ii * params->nx + jj].speeds[1] = w1;
      (*cells_ptr)[ii * params->nx + jj].speeds[2] = w1;
      (*cells_ptr)[ii * params->nx + jj].speeds[3] = w1;
      (*cells_ptr)[ii * params->nx + jj].speeds[4] = w1;
      /* diagonals */
      (*cells_ptr)[ii * params->nx + jj].speeds[5] = w2;
      (*cells_ptr)[ii * params->nx + jj].speeds[6] = w2;
      (*cells_ptr)[ii * params->nx + jj].speeds[7] = w2;
      (*cells_ptr)[ii * params->nx + jj].speeds[8] = w2;
    }
  }

  /* first set all cells in obstacle array to zero */
  for (int ii = 0; ii < params->ny; ii++)
  {
    for (int jj = 0; jj < params->nx; jj++)
    {
      (*obstacles_ptr)[ii * params->nx + jj] = 0;
    }
  }

  /* open the obstacle data file */
  fp = fopen(obstaclefile, "r");

  if (fp == NULL)
  {
    sprintf(message, "could not open input obstacles file: %s", obstaclefile);
    die(message, __LINE__, __FILE__);
  }

   /* read-in the blocked cells list */
  while ((retval = fscanf(fp, "%d %d %d\n", &xx, &yy, &blocked)) != EOF)
  {
    /* some checks */
    if (retval != 3) die("expected 3 values per line in obstacle file", __LINE__, __FILE__);

    if (xx < 0 || xx > params->nx - 1) die("obstacle x-coord out of range", __LINE__, __FILE__);

    if (yy < 0 || yy > params->ny - 1) die("obstacle y-coord out of range", __LINE__, __FILE__);

    if (blocked != 1) die("obstacle blocked value should be 1", __LINE__, __FILE__);

    /* assign to array */
    (*obstacles_ptr)[yy * params->nx + xx] = blocked;	

  }

  /* and close the file */
  fclose(fp);

  /*
  ** allocate space to hold a record of the avarage velocities computed
  ** at each timestep
  */
  *av_vels_ptr = (float*)malloc(sizeof(float) * params->maxIters);
  
  return EXIT_SUCCESS;
}

int finalise(const t_param* params, t_speed** cells_ptr, t_speed** tmp_cells_ptr,
             int** obstacles_ptr, float** av_vels_ptr)
{
  /*
  ** free up allocated memory
  */
  free(*cells_ptr);
  *cells_ptr = NULL;

  free(*tmp_cells_ptr);
  *tmp_cells_ptr = NULL;

  free(*obstacles_ptr);
  *obstacles_ptr = NULL;

  free(*av_vels_ptr);
  *av_vels_ptr = NULL;

  return EXIT_SUCCESS;
}


float calc_reynolds(const t_param params, t_speed* cells, int* obstacles, float* av_vels)
{
  const float viscosity = 1.0 / 6.0 * (2.0 / params.omega - 1.0);
  /* compute Reynold's number by using the last average velocity */
  return av_vels[params.maxIters-1] * params.reynolds_dim / viscosity;
}

float total_density(const t_param params, t_speed* cells)
{
  float total = 0.0;  /* accumulator */

  for (int ii = 0; ii < params.ny; ii++)
  {
    for (int jj = 0; jj < params.nx; jj++)
    {
      for (int kk = 0; kk < NSPEEDS; kk++)
      {
        total += cells[ii * params.nx + jj].speeds[kk];
      }
    }
  }

  return total;
}

int write_values(const t_param params, t_speed* cells, int* obstacles, float* av_vels)
{
  FILE* fp;                     /* file pointer */
  const float c_sq = 1.0 / 3.0; /* sq. of speed of sound */
  float local_density;         /* per grid cell sum of densities */
  float pressure;              /* fluid pressure in grid cell */
  float u_x;                   /* x-component of velocity in grid cell */
  float u_y;                   /* y-component of velocity in grid cell */
  float u;                     /* norm--root of summed squares--of u_x and u_y */

  fp = fopen(FINALSTATEFILE, "w");

  if (fp == NULL)
  {
    die("could not open file output file", __LINE__, __FILE__);
  }

  for (int ii = 0; ii < params.ny; ii++)
  {
    for (int jj = 0; jj < params.nx; jj++)
    {
      /* an occupied cell */
      if (obstacles[ii * params.nx + jj])
      {
        u_x = u_y = u = 0.0;
        pressure = params.density * c_sq;
      }
      /* no obstacle */
      else
      {
        local_density = 0.0;

        for (int kk = 0; kk < NSPEEDS; kk++)
        {
          local_density += cells[ii * params.nx + jj].speeds[kk];
        }

        /* compute x velocity component */
        u_x = (cells[ii * params.nx + jj].speeds[1]
               + cells[ii * params.nx + jj].speeds[5]
               + cells[ii * params.nx + jj].speeds[8]
               - (cells[ii * params.nx + jj].speeds[3]
                  + cells[ii * params.nx + jj].speeds[6]
                  + cells[ii * params.nx + jj].speeds[7]))
              / local_density;
        /* compute y velocity component */
        u_y = (cells[ii * params.nx + jj].speeds[2]
               + cells[ii * params.nx + jj].speeds[5]
               + cells[ii * params.nx + jj].speeds[6]
               - (cells[ii * params.nx + jj].speeds[4]
                  + cells[ii * params.nx + jj].speeds[7]
                  + cells[ii * params.nx + jj].speeds[8]))
              / local_density;
        /* compute norm of velocity */
        u = sqrt((u_x * u_x) + (u_y * u_y));
        /* compute pressure */
        pressure = local_density * c_sq;
      }

      /* write to file */
      fprintf(fp, "%d %d %.12E %.12E %.12E %.12E %d\n", jj, ii, u_x, u_y, u, pressure, obstacles[ii * params.nx + jj]);
    }
  }

  fclose(fp);

  fp = fopen(AVVELSFILE, "w");

  if (fp == NULL)
  {
    die("could not open file output file", __LINE__, __FILE__);
  }

  for (int ii = 0; ii < params.maxIters; ii++)
  {
    fprintf(fp, "%d:\t%.12E\n", ii, av_vels[ii]);
  }

  fclose(fp);

  return EXIT_SUCCESS;
}

void die(const char* message, const int line, const char* file)
{
  fprintf(stderr, "Error at line %d of file %s:\n", line, file);
  fprintf(stderr, "%s\n", message);
  fflush(stderr);
  exit(EXIT_FAILURE);
}

void usage(const char* exe)
{
  fprintf(stderr, "Usage: %s <paramfile> <obstaclefile>\n", exe);
  exit(EXIT_FAILURE);
}

int calc_ncols_from_rank(int rank, int size, int NCOLS)
{
  int ncols;

  ncols = NCOLS / size;       /* integer division */
  if ((NCOLS % size) != 0) {  /* if there is a remainder */
    if (rank < (NCOLS % size))
      ncols += 1;  /* add remainder to last rank */
  }
  
  return ncols;
}


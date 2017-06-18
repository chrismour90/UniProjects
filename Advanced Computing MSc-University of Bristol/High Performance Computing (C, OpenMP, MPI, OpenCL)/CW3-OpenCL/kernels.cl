//Christos Mourouzi
//user id: cm16663
//canditate number: 33747
//email: cm16663@my.bristol.ac.uk


#pragma OPENCL EXTENSION cl_khr_fp64 : enable

#define NSPEEDS         9

kernel void accelerate_flow(global float* cells,
                            global unsigned int* obstacles,
                            const unsigned int nx, const unsigned int ny,
                            const float w1,
							const float w2							
							)
{
  /* modify the 2nd row of the grid */
  const unsigned int ii = ny - 2;
  
  const unsigned int gridsize = nx * ny;
  
  /* get thread global index */
  const unsigned int jj = get_global_id(0);
  
  /* get cells index */
  const unsigned int id = ii * nx + jj; 
  
  /* accelerate flow without if-statement */  
  float mask = (((!obstacles[id])
	&& (cells[gridsize * 3 + id] - w1) > 0.0f 
	&& (cells[gridsize * 6 + id] - w2) > 0.0f 
	&& (cells[gridsize * 7 + id] - w2) > 0.0f )? 1.0f : 0.0f );  
  
  cells[gridsize * 1 + id]+= mask * w1;
  cells[gridsize * 5 + id]+= mask * w2;
  cells[gridsize * 8 + id]+= mask * w2; 
  
  cells[gridsize * 3 + id]-= mask * w1;
  cells[gridsize * 6 + id]-= mask * w2;
  cells[gridsize * 7 + id]-= mask * w2;       
}


kernel void collision(global float* cells,
					  global float* tmp_cells,
					  global unsigned int* obstacles, 
					  global float* av_vels, 
					  unsigned int nx,
					  unsigned int ny,
					  unsigned int tot_cells,
					  float omega,
					  unsigned int tt,
					  local float* tot_u
					  )
{
  //const float c_sq = 1.0f / 3.0f; /* square of speed of sound */
  const float w0 = 4.0f / 9.0f;  /* weighting factor */
  const float w1 = 1.0f / 9.0f;  /* weighting factor */
  const float w2 = 1.0f / 36.0f; /* weighting factor */
    
  /* compute all the intensive float precisions and store them in const variables*/
  const float const1 = 3.0f, const2 = 1.5f , const3 = 4.5f ;
  
  int gridsize= nx * ny;  
  int id = get_global_id(0);
  
  int tid = get_local_id(0);   
	
  private float temp[NSPEEDS];	
  
//////////////////////propagate/////////////////////////////////
  
  
    /* determine indices of axis-direction neighbours
    ** respecting periodic boundary conditions (wrap around) */
    int x= id%nx;
	int y= (int)id/nx;
	 
	int x_e = (x + 1) % nx;      
    int x_w = (x == 0) ?  (x + nx - 1) : (x - 1);
	 
	int y_n = (y + 1) % ny; 
	int y_s = (y == 0) ?  (y + ny - 1) : (y - 1);  
      
   
  /* propagate densities to neighbouring cells, following
  ** appropriate directions of travel and writing into
  ** scratch space grid */
  temp[0] = cells[gridsize * 0 + id];
  temp[1] = cells[gridsize * 1 + (y * nx + x_w)]; /* east */
  temp[2] = cells[gridsize * 2 + (y_s * nx + x)]; /* north */
  temp[3] = cells[gridsize * 3 + (y * nx + x_e)]; /* west */
  temp[4] = cells[gridsize * 4 + (y_n * nx + x)]; /* south */
  temp[5] = cells[gridsize * 5 + (y_s * nx + x_w)]; /* north-east */
  temp[6] = cells[gridsize * 6 + (y_s * nx + x_e)]; /* north-west */
  temp[7] = cells[gridsize * 7 + (y_n * nx + x_e)]; /* south-west */
  temp[8] = cells[gridsize * 8 + (y_n * nx + x_w)]; /* south-east */
   

  
//////////////////////rebound/////////////////////////////////

   
      /* if the cell contains an obstacle then rebound */
      if (obstacles[id])
      {
        /* called after propagate, so taking values from scratch space
        ** mirroring, and writing into main grid */
		tmp_cells[gridsize * 1 + id]=temp[3];
        tmp_cells[gridsize * 2 + id]=temp[4];
        tmp_cells[gridsize * 3 + id]=temp[1];
        tmp_cells[gridsize * 4 + id]=temp[2];
        tmp_cells[gridsize * 5 + id]=temp[7];
        tmp_cells[gridsize * 6 + id]=temp[8];
        tmp_cells[gridsize * 7 + id]=temp[5];
        tmp_cells[gridsize * 8 + id]=temp[6];	     

        tot_u[tid] = 0.0f;			
		
      }

//////////////////////collision/////////////////////////////////
      else
      {
        /* compute local density total */
        float local_density = 0.0f;

		#pragma unroll
        for (int kk = 0; kk < NSPEEDS; kk++)
        {
          local_density += temp[kk];
        }
		
		/*compute the inverse of local density*/
		float loc1= 1 / local_density;

        /* compute x velocity component */
        float u_x = (temp[1]
                      + temp[5]
                      + temp[8]
                      - (temp[3]
                         + temp[6]
                         + temp[7]))
                     * loc1;
					 
        /* compute y velocity component */
        float u_y = (temp[2]
                      + temp[5]
                      + temp[6]
                      - (temp[4]
                         + temp[7]
                         + temp[8]))
                     *loc1;
		
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
        float d_equ[NSPEEDS], w11=w1 * local_density, w22= w2 * local_density, u_sq1= 1.0f - u_sq*const2;
		
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
		#pragma unroll
        for (int kk = 0; kk < NSPEEDS; kk++)        		  	
          tmp_cells[gridsize * kk + id] = temp[kk] + omega * (d_equ[kk] - temp[kk]);    
		  
		   /* velocity squared */      
        tot_u[tid] = sqrt(u_sq);	
    
   	  
      }
	  
	  barrier(CLK_LOCAL_MEM_FENCE);
	  
///////////////////////////reduction///////////////////////
		 
	for (unsigned int s=get_local_size(0)/2; s>0; s=s/2)
	{
		if (tid < s)
		{
		tot_u[tid] += tot_u[tid + s];
		}		
		barrier(CLK_LOCAL_MEM_FENCE);
	}		

	
	if (tid==0)
	{
	    av_vels[tt * get_num_groups(0) + get_group_id(0)]=tot_u[0];		
	}
	 
	 
}


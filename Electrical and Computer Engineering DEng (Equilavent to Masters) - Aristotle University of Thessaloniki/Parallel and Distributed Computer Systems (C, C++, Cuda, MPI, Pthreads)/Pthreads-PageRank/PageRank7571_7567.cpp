// Mourouzis Christos AEM: 7571
// Agrotis Ioannis    AEM: 7567
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <pthread.h> 
#include  <time.h>


#pragma warning(disable : 4996)

pthread_t *thread;
pthread_attr_t joinable;
pthread_barrier_t barrier;
pthread_mutex_t mutex;


int **E, **L, *c;
double *x, *z;
int counter = 0;
double err = 0.1;
char *source, *results;
int nodes, edges,nthreads;


void menu()
{
	int code;
	printf("Select a site to run\n");
	printf("\nCode        Dataset         Nodes          Edges");
	printf("\n-------------------------------------------------");
	printf("\n 1         Amazon0302       262111        1234877");
	printf("\n 2         Amazon0601       403394        3387388");
	printf("\n 3         web-Google       875713        5105039\n");

	printf("\n Insert Code: ");
	scanf("%d", &code);
	if (code == 1)
	{
		source = "Amazon0302.txt";
		nodes = 262111;
		edges = 1234877;
		results = "Amazon0302.bin";
	}
	else if (code == 2)
	{
		source = "Amazon0601.txt";
		nodes = 403394;
		edges = 3387388;
		results = "Amazon0601.bin";
	}
	else if (code == 3)
	{
		source = "web-Google.txt";
		nodes = 875713;
		edges = 5105039;
		results = "web-Googlebin";
	}
printf("Insert number of threads: ");
	scanf("%d", &nthreads);
}

//import data

void import_data()
{
	FILE *fp;
	char a, b;
	printf("\nImporting data...");
	fp = fopen(source, "r+");
	if (fp == NULL)
	{
		printf("Error open input file!\n");
		exit(1);
	}

	E = (int **)malloc(2 * sizeof(int*));

	if (E == NULL ){

		exit(-1);
	}
	
	for (int i = 0; i < 2; i++)
		{
			E[i] = (int *)malloc(edges * sizeof(int));
			if (E[i] == NULL )
			{
				exit(-2);
			}
		}
	

	int val, acount, bcount;
	char xx[10], yy[10];
	for (int i = 0; i<edges; i++)
	{

		acount = 0;
		bcount = 0;
		fscanf(fp, "%c", &a);
		for (int k = 0; k < 10; k++)
		{
			xx[k] = '\n';
			yy[k] = '\n';
		}
		xx[acount] = a;
		acount++;
		while (true){
			val = fscanf(fp, "%c", &a);
			if (a == 9)
			{
				break;
			}
			xx[acount] = a;
			acount++;
		}
		E[0][i] = atoi(&xx[0]);
		fscanf(fp, "%c", &b);
		yy[bcount] = b;
		bcount++;
		while (true){
			val = fscanf(fp, "%c", &b);
			if (b == '\n')
			{
				break;
			}
			yy[bcount] = b;
			bcount++;
		}
		E[1][i] = atoi(&yy[0]);

	}
	fclose(fp);
}

//save data
void save_results(){

	FILE *outfile;

	printf("\nSaving data to file: %s\n\n", results);

	if ((outfile = fopen(results, "wb")) == NULL){
		printf("Can't open output file");
	}

	fwrite(x, sizeof(double), edges, outfile);

	fclose(outfile);
}

//error handler

double cal_err()
{
	double *e;
	int maxIdx, i;
	double max;
	e = (double *)malloc(nodes*sizeof(double));
	for (i = 0; i < nodes; i++)
	{
		e[i] = x[i] - z[i];
		if (e[i] < 0)
		{
			e[i] = -e[i];
		}
	}
	max = e[0];
	maxIdx = 0;
	for (int i = 1; i < nodes; i++)
	{
		if (e[i]>max)
		{
			max = e[i];
			maxIdx = i;
		}
	}
	return max;
}

// page rank
void *rank(void *args){
	clock_t start1 = clock();
	clock_t start2 = clock();
	clock_t end1;
	int tid = *((int *) (&args));
	float secs;
	int cnt = 0;

	for (int i = tid; i<nodes; i += nthreads)
	{
		L[i] = (int *)malloc(sizeof(int));
		c[i] = 0;
		for (int j = 0; j < edges; j++)
		{
			if (E[0][j] == i)
			{
				c[i]++;
				if (NULL == (L[i] = (int *)realloc(L[i], c[i] * sizeof(int))))
				{
					printf("Realloc failed\n");
					exit(-1);
				}
				L[i][c[i] - 1] = E[1][j];
			}
		}

	}

	pthread_barrier_wait(&barrier);
	if (tid == 0){
		end1 = clock();
		secs = (float)(end1 - start2) / CLOCKS_PER_SEC;
		printf("\nTime for Linking : %f\n", secs);
	}

	double p = 0.85;
	double delta = (1 - p) / (double)nodes;

	if (tid == 0)
	{
		printf("\nCalculating Possibilities..");
	}
	clock_t start3 = clock();
	clock_t start4 = clock();
	cnt = 0;
	do
	{
		for (int i = tid; i<nodes; i += nthreads)
		{
			z[i] = x[i];
			x[i] = 0;
		}

		pthread_barrier_wait(&barrier);

		for (int i = tid; i<nodes; i += nthreads)
		{
			pthread_mutex_lock(&mutex);

			if (c[i] == 0)
			{
				for (int j = 0; j < nodes; j++)
				{
					x[j] += z[i] / (double)nodes;
				}
			}
			else
			{
				for (int j = 0; j < c[i]; j++)
				{
					x[L[i][j]] += z[i] / c[i];
				}
			}

			pthread_mutex_unlock(&mutex);

		}

		pthread_barrier_wait(&barrier);

		for (int i = tid; i<nodes; i += nthreads)
		{
			x[i] = p*x[i] + delta;
		}

		pthread_barrier_wait(&barrier);


		if (tid == 0){
			err = cal_err();
		}

		pthread_barrier_wait(&barrier);
		if (tid == 0){
			counter++;
			printf("\ncounter = %d, error = %f", counter, err);
		}

	} while (err > 0.0001);
	pthread_exit(NULL);
}



int main()
{
	int rc;

	menu();

//initialize pthreads

	pthread_attr_init(&joinable);
	pthread_attr_setdetachstate(&joinable, PTHREAD_CREATE_JOINABLE);
	pthread_barrier_init(&barrier, NULL, nthreads);
	pthread_mutex_init(&mutex, NULL);
	thread = (pthread_t *)malloc(nthreads*sizeof(pthread_t));

//time clock 1 start
	
	clock_t start1 = clock();

//read data
	import_data();

//time clock 1 end
	clock_t end1 = clock();

	float secs = (float)(end1 - start1) / CLOCKS_PER_SEC;
	printf("\nTime for reading files: %f\n", secs);


//allocate memory
	if (NULL == (L = (int **)malloc(nodes * sizeof(int*)))){
		printf("Malloc failed\n");
		exit(-1);
	}
	if (NULL == (c = (int *)malloc(nodes * sizeof(int)))){
		printf("Malloc failed\n");
		exit(-1);
	}
	if (NULL == (x = (double *)malloc(nodes*sizeof(double)))){
		printf("Malloc failed\n");
		exit(-1);
	}
	if (NULL == (z = (double *)malloc(nodes*sizeof(double)))){
		printf("Malloc failed\n");
		exit(-1);
	}


//initialize matrices

	for (int i = 0; i < nodes; i++)
	{
		z[i] = 0;
		x[i] = 1 / (double)nodes;
	}

//time clock 2 start
	clock_t start2 = clock();

//page_rank
	for (int i = 0; i<nthreads; i++){
		rc = pthread_create(&thread[i], &joinable, rank, (void *)i);
		if (rc){
			printf("Thread [%d] was not created\n", i);
			exit(4);
		}
	}
	for (int i = 0; i<nthreads; i++) {
		pthread_join(thread[i], NULL);
	}

//time clock 2 end

	clock_t end2 = clock();
	secs = (float)(end2 - start2) / CLOCKS_PER_SEC;
	printf("\n\nNumber of Iterations: %d ", counter);
	printf("\nTotal Kernel Time for PageRank Elapsed: %f\n", secs);

//save results
	save_results();
	system("pause");
	return 0;
}

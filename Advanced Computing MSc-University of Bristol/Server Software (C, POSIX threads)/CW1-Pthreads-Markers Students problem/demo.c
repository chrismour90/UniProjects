/* Christos Mourouzi
 * Canditate Number: 33747
 * email: cm16663@my.bristol.ac.uk
 */

/*
 * This is a skeleton program for COMSM2001 (Server Software) coursework 1
 * "the project marking problem". Your task is to synchronise the threads
 * correctly by adding code in the places indicated by comments in the
 * student, marker and run functions.
 * You may create your own global variables and further functions.
 * The code in this skeleton program can be used without citation in the files
 * that you submit for your coursework.
 */
 
 
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <time.h>
#include <sys/time.h>

/*
 * Parameters of the program. The constraints are D < T and
 * S*K <= M*N.
 */
struct demo_parameters {
    int S;   /* Number of students */
    int M;   /* Number of markers */
    int K;   /* Number of markers per demo */
    int N;   /* Number of demos per marker */
    int T;   /* Length of session (minutes) */
    int D;   /* Length of demo (minutes) */
};

/* Global object holding the demo parameters. */
struct demo_parameters parameters;

/* The demo start time, set in the main function. Do not modify this. */
struct timeval starttime;

/* 
 * You may wish to place some global variables here. 
 * Remember, globals are shared between threads.
 * You can also create functions of your own.
 */
int *students, *markers_for_students, *finished; 
int last_demo, in, assigned_to; //last_demo=timeout flag, in=index that shows the last student that got in the lab, assigned_to=index that shows the last student that is assigned to markers

pthread_mutex_t mut;
pthread_cond_t grab, ready, demo_finished;

/*
 * timenow(): returns current simulated time in "minutes" (cs).
 * Assumes that starttime has been set already.
 * This function is safe to call in the student and marker threads as
 * starttime is set in the run() function.
 */
int timenow() {
    struct timeval now;
    gettimeofday(&now, NULL);
    return (now.tv_sec - starttime.tv_sec) * 100 + (now.tv_usec - starttime.tv_usec) / 10000;
}

/* delay(t): delays for t "minutes" (cs) */
void delay(int t) {
    struct timespec rqtp, rmtp;
    t *= 10;
    rqtp.tv_sec = t / 1000;
    rqtp.tv_nsec = 1000000 * (t % 1000);
    nanosleep(&rqtp, &rmtp);
}

/* panic(): simulates a student's panicking activity */
void panic() {
    delay(random() % (parameters.T - parameters.D));
}

/* demo(): simulates a demo activity */
void demo() {
    delay(parameters.D);
}

/*
 * A marker thread. You need to modify this function.
 * The parameter arg is the number of the current marker and the function
 * doesn't need to return any values.
 * Do not modify the printed output as it will be used as part of the testing.
 */
void *marker(void *arg) {
    int markerID = *(int *)arg;
    
    /*
     * The following variable is used in the printf statements when a marker is
     * grabbed by a student. It shall be set by this function whenever the
     * marker is grabbed - and before the printf statements referencing it are
     * executed.
     */
    int err, job, studentID;
    
    /* 1. Enter the lab. */
    printf("%d marker %d: enters lab\n", timenow(), markerID);    
		
    /* A marker marks up to N projects. */
    /* 2. Repeat (N times). */
	for (job=0; job<parameters.N; job++)
	{ 
		/*    (a) Wait to be grabbed by a student. */	
		err=pthread_mutex_lock(&mut); //lock the mutex
		if (err)
		{
			printf("Error in locking mutex in grab state \n");
			abort();
		}
		while (in==assigned_to && !last_demo) //while a student is no available or not last demo wait
		{
			err=pthread_cond_wait(&grab, &mut);
			if (err)
			{
				printf("Error while waiting to be grabbed\n");
				exit(1);
			}
		}
		
		studentID=students[assigned_to]; // get the student that is available
		markers_for_students[studentID]--;	//decrease the number of the markers needed for the student
		
		if (!markers_for_students[studentID]) //if student has the markers he needs point to the next student so next markers can be grabbed by him
		{
     		assigned_to=(assigned_to+1)%parameters.S; //if assigned_to = number of students students reinitialize it
		}
		
		err=pthread_mutex_unlock(&mut); //unlock the mutex
		if (err)
		{
			printf("Error in unlocking mutex in grab state \n");
			abort();
		}
		
		// if there no more time get out!
		if (last_demo)
		{
			break;
		}
		
		/*    (b) Wait for the student's demo to begin */
		err=pthread_mutex_lock(&mut); //lock the mutex
		if (err)
		{
			printf("Error in locking mutex in demo begin state\n");
			abort();
		}
		
		/* The following line shall be printed when a marker is grabbed by a student. */
        printf("%d marker %d: grabbed by student %d (job %d)\n", timenow(), markerID, studentID, job + 1);
		
		if (!markers_for_students[studentID]) //if a student has all the markers he needs then tell him is ready to start the demo
		{
			err=pthread_cond_broadcast(&ready); //inform everyone that a demo is starting
			if (err)
			{
				printf("Error while waiting for the demo to begin\n");
				abort();
			}
			
		}	
		
	    err=pthread_mutex_unlock(&mut); //unlock the mutex
		if (err)
		{
			printf("Error in unlocking mutex in demo begin state\n");
			abort();
		}
		
		 /*    (c) Wait for the demo to finish.
		  *        Do not just wait a given time -
          *        let the student signal when the demo is over.
		  */
		  
		err=pthread_mutex_lock(&mut); //lock the mutex
		if (err)
		{
			printf("Error in locking mutex in demo finish state\n");
			abort();
		}
		
		while (!finished[studentID]) //wait until the student informs that he finished the demo
		{
			err=pthread_cond_wait(&demo_finished, &mut);
			if (err)
			{
				printf("Error while waiting for the demo to finish\n");
				abort();
			}
		}		
				
		err=pthread_mutex_unlock(&mut); //unlock the mutex
		if (err)
		{
			printf("Error in unlocking mutex in demo finish state\n");
			abort();
		}
		
        /*  The following line shall be printed when a marker has finished attending a demo. */
        printf("%d marker %d: finished with student %d (job %d)\n", timenow(), markerID, studentID, job + 1);	
		
		// if there no more time get out!
		if (last_demo)
		{
			job++; //if there is a timeout increase the job as it won't be increased in the for loop because there will be a break
			break;
		}					
	}
    
    /*    (d) Exit the lab.	*/
	if (job == parameters.N) //if all jobs done then print finished
		printf("%d marker %d: exits lab (finished %d jobs)\n", timenow(), markerID, parameters.N);				
	else //else print timeout
		printf("%d marker %d: exits lab (timeout)\n", timenow(), markerID);	
  
    pthread_exit(NULL);
    return NULL;
}


/*
 * A student thread. You must modify this function.
 */
void *student(void *arg) {
    /* The ID of the current student. */
    int studentID = *(int *)arg;
    int err;
    /* 1. Panic! */
    printf("%d student %d: starts panicking\n", timenow(), studentID);
    panic();

    /* 2. Enter the lab. */
    printf("%d student %d: enters lab\n", timenow(), studentID);
    
	err=pthread_mutex_lock(&mut); //lock the mutex
	if (err)
	{
		printf("Error in locking mutex in entering the lab state\n");
		abort();
	}
	
	// update the students list
	students[in]=studentID;
	in=(in+1)%parameters.S; //increase the number of students that got in the lab
		
	err=pthread_mutex_unlock(&mut); //unlock the mutex
	if (err)
	{
		printf("Error in unlocking mutex in entering the lab state\n");
		abort();
	}
	
		
    /* 3. Grab K markers. */
    err=pthread_mutex_lock(&mut); //lock the mutex
	if (err)
	{
		printf("Error in locking mutex in waking up the markers state\n");
		abort();
	}
	
	err=pthread_cond_broadcast(&grab); //wake up the markers and wait until enough markers are available
	if (err)
	{
		printf("Error while waking up the markers\n");
		abort();
	}

    err=pthread_mutex_unlock(&mut); //unlock the mutex
	if (err)
	{
		printf("Error in unlocking mutex in waking up the markers state\n");
		abort();
	}	
	 
	err=pthread_mutex_lock(&mut); //lock the mutex
	if (err)
	{
		printf("Error in locking mutex in waiting for enough markres\n");
		abort();
	}
	
	while (markers_for_students[studentID] && !last_demo) //while not all K markers are grabbed and there is no timeout then wait to be signaled to start the demo
	{
		err=pthread_cond_wait(&ready, &mut);
		if (err)
		{
			printf("Error while waiting for the student to be ready\n");
			abort();
		}
	}
	
	err=pthread_mutex_unlock(&mut); //lock the mutex
	if (err)
	{
		printf("Error in unlocking mutex in waiting for enough markres\n");
		abort();
	}
	
    /* 4. Demo! */
    /*
     * If the student succeeds in grabbing K markers and there is enough time left
     * for a demo, the following three lines shall be executed in order.
     * If the student has not started their demo and there is not sufficient time
     * left to do a full demo, the following three lines shall not be executed
     * and the student proceeds to step 5.
     */
	 
	if (!last_demo) //if there is no timeout then start the demo
	{
		printf("%d student %d: starts demo\n", timenow(), studentID);
		demo();
		printf("%d student %d: ends demo\n", timenow(), studentID); 	
		
		err=pthread_mutex_lock(&mut); //lock the mutex
	    if (err)
		{
			printf("Error in locking mutex in finishing the demo state\n");
			abort();
		}
		
		finished[studentID]=1; //update finished array
		
		err=pthread_cond_broadcast(&demo_finished); //inform everyone that the demo is finished
		if (err)
		{
			printf("Error while finishing the demo\n");
			abort();
		}
		
		err=pthread_mutex_unlock(&mut); //unlock the mutex
	    if (err)
		{
			printf("Error in unlocking mutex in finishing the demo state\n");
			abort();
		}
		/* 5a. Exit the lab. (finished) */
		printf("%d student %d: exits lab (finished)\n", timenow(), studentID);
		
	}
	
	else //if timeout
	{
		err=pthread_mutex_lock(&mut); //lock the mutex
	    if (err)
		{
			printf("Error in locking mutex in timeout state\n");
			abort();
		}
		
		finished[studentID]=1; //update finished array
		
		err=pthread_cond_broadcast(&demo_finished); //if there is timeout 
		if (err)
		{
			printf("Error while finishing the demo in timeout state\n");
			abort();
		}
		
		err=pthread_mutex_unlock(&mut); //unlock the mutex
	    if (err)
		{
			printf("Error in unlocking mutex in timeout state\n");
			abort();
		}
		/* 5b. Exit the lab. (timeout) */
		printf("%d student %d: exits lab (timeout)\n", timenow(), studentID);
	} 
    
	pthread_exit(NULL);
    return NULL;
}

/* The function that runs the session.
 * You MAY want to modify this function.
 */
void run() {
    int i, err;
    int markerID[100], studentID[100];
    pthread_t markerT[100], studentT[100];
    
    last_demo=0; // initialize timeout flag
    in=0; //initialize indexes
    assigned_to=0;
	
    printf("S=%d M=%d K=%d N=%d T=%d D=%d\n",
        parameters.S,
        parameters.M,
        parameters.K,
        parameters.N,
        parameters.T,
        parameters.D);
    gettimeofday(&starttime, NULL);  /* Save start of simulated time */

	/* Initialize everything */
	pthread_mutex_init(&mut, NULL); //initialize the mutex
	pthread_cond_init(&grab, NULL); //initialize condition variables
	pthread_cond_init(&ready, NULL);
	pthread_cond_init(&demo_finished, NULL);
	
	// allocate memory
	students=calloc(parameters.S, sizeof(int));	//allocate the memory and set all elements to zero
	if (students==NULL) //check if the matrix is allocated correctly
	{
		printf("Out of memory for students array\n");
		exit(1); //if error abort
	}
	
	markers_for_students=calloc(parameters.S, sizeof(int));	//allocate the memory and set all elements to zero
	if (markers_for_students==NULL) //check the matrix is allocated correctly
	{
		printf("Out of memory for markers_for_students_array\n");
		exit(1); //if error abort
	}
	
	finished=calloc(parameters.S, sizeof(int));	//allocate the memory and set all elements to zero
	if (finished==NULL) //check the matrix is allocated correctly
	{
		printf("Out of memory for finished array\n");
		exit(1); //if error abort
	}
	
	for (i=0; i<parameters.S; i++)
	{
		students[i]=-1; //students that got in the lab
		markers_for_students[i]=parameters.K; //all students can take up to K markers
	}
	
    /* Create S student threads */
    for (i = 0; i<parameters.S; i++) {
        studentID[i] = i;
        err = pthread_create(&studentT[i], NULL, student, &studentID[i]);
		if (err)
		{
			printf("Error while creating student thread = %d\n", studentID[i]);
			abort();
		}
    }
    /* Create M marker threads */
    for (i = 0; i<parameters.M; i++) {
        markerID[i] = i;
        err = pthread_create(&markerT[i], NULL, marker, &markerID[i]);
		if (err)
		{
			printf("Error while creating marker thread = %d\n", markerID[i]);
			abort();
		}
    }

    /* With the threads now started, the session is in full swing ... */
    delay(parameters.T - parameters.D);

    /* 
     * When we reach here, this is the latest time a new demo could start.
     * You might want to do something here or soon after.
     */
	 
	 // inform everyone that there is no more time for a demo to start. get out of the lab!
	 last_demo=1;
	 
	 err=pthread_cond_broadcast(&grab); //wake up the markers and wait until enough markers are available
	 if (err)
	 {
		printf("Error in broadcasting grabbed after timeout \n");
		abort();
	 }
	 
	 err=pthread_cond_broadcast(&ready); //wake up the markers and wait until enough markers are available
	 if (err)
	 {
		printf("Error in broadcasting ready after timeout \n");
		abort();
	 }
	 
	 err=pthread_cond_broadcast(&demo_finished); //wake up the markers and wait until enough markers are available
	 if (err)
	 {
		printf("Error in broadcasting finished after timeout \n");
		abort();
	 }
	 
	 

    /* Wait for student threads to finish */
    for (i = 0; i<parameters.S; i++) {
       err = pthread_join(studentT[i], NULL);
	   if (err)
		{
			printf("Error while joining the student threads\n");
			abort();
		}
    }

    /* Wait for marker threads to finish */
    for (i = 0; i<parameters.M; i++) {
        err = pthread_join(markerT[i], NULL);
		if (err)
		{
			printf("Error while joining the marker threads\n");
			abort();
		}
    }
	
}

/*
 * main() checks that the parameters are ok. If they are, the interesting bit
 * is in run() so please don't modify main().
 */
int main(int argc, char *argv[]) {
    if (argc < 6) {
        puts("Usage: demo S M K N T D\n");
        exit(1);
    }
    parameters.S = atoi(argv[1]);
    parameters.M = atoi(argv[2]);
    parameters.K = atoi(argv[3]);
    parameters.N = atoi(argv[4]);
    parameters.T = atoi(argv[5]);
    parameters.D = atoi(argv[6]);
    if (parameters.M > 100 || parameters.S > 100) {
        puts("Maximum 100 markers and 100 students allowed.\n");
        exit(1);
    }
    if (parameters.D >= parameters.T) {
        puts("Constraint D < T violated.\n");
        exit(1);
    }
    if (parameters.S*parameters.K > parameters.M*parameters.N) {
        puts("Constraint S*K <= M*N violated.\n");
        exit(1);
    }
    
    // We're good to go.

    run();
    
	/* Free Memory */
	free(students);
	free(markers_for_students);
	free(finished);
	
	/* Destroy mutex and condition variables */
	pthread_mutex_destroy(&mut);
	pthread_cond_destroy(&grab);
	pthread_cond_destroy(&ready);
	pthread_cond_destroy(&demo_finished);
	pthread_exit(NULL);
    return 0;
}

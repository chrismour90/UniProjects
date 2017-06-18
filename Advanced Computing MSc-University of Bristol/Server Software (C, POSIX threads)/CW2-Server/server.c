/* Server program for key-value store. 

Name: Christos Mourouzi
Canditate Number: 33747
email: cm16663@my.bristol.ac.uk

*/

#include "kv.h"
#include "parser.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <pthread.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <poll.h>
#include <semaphore.h>
#include <stdbool.h>

#define NTHREADS  4
#define BACKLOG 10

/* Add anything you want here. */
pthread_mutex_t mut, data_mut;
pthread_cond_t new_conn;
int client_fds[100];
int counter_fds=0;
//int full=NTHREADS;
bool connflag=false;
bool shut_down=false;
bool full=false;
int inner_counter=0;
int main_counter=0;
//sem_t queue_full;

/* A worker thread. You should write the code of this function. */
void *worker(void* p) {
char buffer[LINE];
enum DATA_CMD cmd;
char* key;
char* text, err;
int dfd;
int threadID = *(int *)p;
char* get;
ssize_t rc;

printf("Hello from thread %d\n", threadID);
while(1)
{

	err=pthread_mutex_lock(&mut);
	if (err)
	{
		perror("Error while locking the mutex");
		abort(); //if error abort
	}

	while(!connflag && !shut_down) 
	{
		err=pthread_cond_wait(&new_conn, &mut); //wait while there is no connection or a shutdown command
		if (err)
		{
			perror("Error in condition wait");
			abort(); //if error  abort
		}
	}
   
    if (shut_down) //if shutdown unlock the mutex and exit
    {
    	err=pthread_mutex_unlock(&mut);
    	if (err)
		{
			perror("Error while unlocking the mutex");
			abort(); //if error abort
		}
    	break;
    }
  
    connflag=false; //change the connflag back to false so no other threads connect to the same fd
	dfd=client_fds[counter_fds];
	printf("Got a data port connection= %d, thread %d\n", counter_fds+1, threadID); //for debuggin
	counter_fds=(counter_fds+1)%100; //if counter=100 reset it

    inner_counter++; //counts the concurrent connections
    printf("Concurrent connections=%d\n",inner_counter); //just for debugging

	if ((inner_counter)==NTHREADS) //if current connections handled=NTHREADS then inform main that cannot pass anymore connections
	{	full=true;
		printf("Queue is full. Do not accept anymore connections in the data port\n");			
	}		
	err=pthread_mutex_unlock(&mut);
    if (err)
	{
		perror("Error while unlocking the mutex");
		abort(); //if error abort
	}

    strcpy(buffer,"Welcome to the KV Store\n"); // welcome message
	write(dfd, buffer, strlen(buffer));
	
	while(1) //until there is not an empty line command keep reading
	{
	  rc=read(dfd,buffer,LINE); //here thread is blocked until it gets a message from the client
	  if (rc<0) //if error break and close the connection
	  {
		perror("Error in reading from client");
		break; 
	  }

	  else if (!rc) //if the client closed the terminal break and close the connection
	  {
		printf("Client in the data port closed the connection unexpectfully\n");
		break; 
	  }

	  printf("READ something from thread %d\n",threadID); 
	  parse_d(buffer, &cmd, &key, &text); //parse the command and handle it

	  err=pthread_mutex_lock(&data_mut); //protect the database from a data race
      if (err)
	  {
			perror("Error while locking the data mutex");
			abort(); //if error abort
	  }

	  if (cmd==D_PUT) //put command
	  {
	  	char* put=malloc(strlen(text+1));
	  	strcpy(put,text);
	  	if (createItem(key,put)==0)
	  		strcpy(buffer,"Success. Key created.\n"); //put succeeded
	  	else if (createItem(key,put)==-1)
	  	{
	  		if (itemExists(key) && !updateItem(key,put)) //if key existis then updtate it
	  			strcpy(buffer,"Key already existed! Update success!\n");
	  		else if (!itemExists(key)) //if key does not exist
	  			strcpy(buffer,"ERROR! Item does not exist!\n"); 
	  		else //else error
	  			strcpy(buffer,"ERROR! Fail storing the key!\n"); 
	  	}
	  	
	  }

	  else if (cmd==D_GET) //get command
	  {	  

	  	get=findValue(key);
	  	if (get==NULL) //key does not exist
	  		strcpy(buffer, "Key does not exist!\n");
	  	else if (itemExists(key)==1) //if it exists get the value from the heap and write to the client
	  	{
	  		strcpy(buffer,get);
	  		strcat(buffer,"\n");
	  	}

	  }

	  else if (cmd==D_COUNT) //count items
	  {
	  	sprintf(buffer, "%d\n", countItems());
	  }

	  else if (cmd==D_DELETE) //delete key
	  {
	  	if (deleteItem(key,0)==0)
	  		strcpy(buffer,"Success. Key deleted.\n");
	  	else if (deleteItem(key,0)==-1)
	  		strcpy(buffer,"ERROR! Fail deleting the item.\n");
	  }
      
      else if (cmd==D_EXISTS) //key exists
	  {
	  	sprintf(buffer, "%d\n", itemExists(key));
	  }

	  else if (cmd==D_END) //if empty line exit the database and wait for another connection
	  {	  	
        err=pthread_mutex_unlock(&data_mut); //unlock the mutex before you exit
        if (err)
	  	{
			perror("Error while unlocking the data mutex");
			abort(); //if error abort
	  	}
	  	break; 
	  }

	  //errors
	  else if (cmd==D_ERR_OL)
	  {
	  	strcpy(buffer,"ERROR! Line is too long.\n");
	  }

	  else if (cmd==D_ERR_INVALID)
	  {
	  	strcpy(buffer,"ERROR! Invalid command.\n");
	  }

	  else if (cmd==D_ERR_SHORT)
	  {
	  	strcpy(buffer,"ERROR! Too few parameters.\n");
	  }

	  else if (cmd==D_ERR_LONG)
	  {
	  	strcpy(buffer,"ERROR! Too many parameters.\n");
	  }

      err=pthread_mutex_unlock(&data_mut); //unlock the data mutex
      if (err)
	  {
			perror("Error while unlocking the data mutex");
			abort(); //if error abort
	  }

      write(dfd,buffer,strlen(buffer));	  
    
	}	
   	
   	strcpy(buffer,"Connection Closed! Goodbye!\n");
    write(dfd,buffer,strlen(buffer));
	close(dfd); //close the connection if you exit the datastore

    err=pthread_mutex_lock(&mut);    
    if (err)
	{
		perror("Error while locking the mutex");
		abort(); //if error abort
	}
    inner_counter--; //just for debugging
    full=false; //change full flag so main can signal to the threads
    if (main_counter>counter_fds)
    	connflag=true;
    printf("Thread %d finished! Concurrent connections now=%d\n", threadID, inner_counter);
    err=pthread_mutex_unlock(&mut);
    if (err)
	{
		perror("Error while locking the mutex");
		abort(); //if error abort
	}

}

printf("Shutting down, thread %d\n", threadID); //if shutdown occurs

pthread_exit(NULL); //exit and join the other other threads
return NULL;

}

/* You may add code to the main() function. */
int main(int argc, char** argv) {
    int cport, dport; /* control and data ports. */
    int csocket, dsocket, err, p, i;
    struct sockaddr_in control, data;
    int workerID[100];
    pthread_t workers[100];
    struct pollfd pfd[2];
    char buffer[LINE];
    int cfd,dfd;
    enum CONTROL_CMD control_parse;
    ssize_t rc;

	if (argc < 3) {
        printf("Usage: %s data-port control-port\n", argv[0]);
        exit(1);
	} else {
        cport = atoi(argv[1]); // ./server CPORT DPORT
        dport = atoi(argv[2]);
	}
	
    pthread_mutex_init(&mut, NULL); //initialize the mutex
    pthread_mutex_init(&data_mut, NULL); //initialize the mutex
	pthread_cond_init(&new_conn, NULL); //initialize condition variables

    /*Create NTHREADS threads */
    for (i = 0; i<NTHREADS; i++) {
        workerID[i] = i;
        err = pthread_create(&workers[i], NULL, worker, &workerID[i]);
		if (err)
		{
			printf("Error while creating worker thread = %d\n", workerID[i]);
			abort();
		}
    }
    
    // Create the control and the data socket
    csocket=socket(AF_INET, SOCK_STREAM,0);
    if (csocket==-1)
    {
    	perror("ERROR! Control socket was not created");
    	exit(1);
    }
   
    dsocket=socket(AF_INET, SOCK_STREAM,0);
    if (dsocket==-1)
    {
    	perror("ERROR! Data socket was not created");
    	exit(1);
    }

    printf("SUCCESS! Sockets created\n");

    //initialize sockets
    socklen_t len=sizeof(control);
    socklen_t len2=sizeof(data);
    memset(&control, 0, len);
    memset(&data, 0, len2);
  
    control.sin_family=AF_INET;
    control.sin_addr.s_addr=htonl(INADDR_LOOPBACK);
    control.sin_port=htons(cport);

    data.sin_family=AF_INET;
    data.sin_addr.s_addr=htonl(INADDR_LOOPBACK);
    data.sin_port=htons(dport);

    //bind to the sockets
	if( bind(csocket, (struct sockaddr *) &control, sizeof(struct sockaddr_in)) < 0 )
	{
		perror("ERROR! Cannot bind to the control socket");
		close(csocket);
		exit(1);
	}
    
    if( bind(dsocket, (struct sockaddr *) &data, sizeof(struct sockaddr_in)) < 0 )
	{
		perror("ERROR! Cannot bind to the control socket");
		close(dsocket);
		exit(1);
	}

    //listen to the sockets
    if( listen(csocket, BACKLOG) < 0 )
	{
		perror("Failed to listen on the control socket \n");
		close(csocket);
		exit(1);
	}

	if( listen(dsocket, BACKLOG) < 0 )
	{
		perror("Failed to listen on the data socket \n");
		close(dsocket);
		exit(1);
	}

	// set pollfd struct 
	pfd[0].fd = csocket; //poll the control fd
	pfd[0].events = POLLIN;
    
    pfd[1].fd = dsocket; //poll the data fd
	pfd[1].events = POLLIN;
    
    //wait for connections
    while (1)
    {
      p=poll(pfd, 2, -1); //poll the sockets without a timeout
      
      if (p==0)
       		{
       			printf("Timeout!\n"); 
       		}
   	  else if (p==-1)    
   	    	{
   	    		perror("ERROR! Something wrong with the poll\n");
   	    		exit(1);
   	    	}
   	  else
   	  {          
      			if (pfd[0].revents & POLLIN) //if something happened on the control port
				{
					//accept connection read, write for control port as a main thread
					printf("We have a connection in the control port!\n");
					cfd = accept(csocket, (struct sockaddr *)&control, &len); //accept the connection
					if (cfd<0)
					{
						perror("Error while accepting a connection in the control port");
						abort();
					}
					
					strcpy(buffer,"Welcome Adminstrator!\n"); // welcome message
					write(cfd, buffer, strlen(buffer));

					printf("Read from control port!\n");
                    rc=read(cfd,buffer,LINE); //if error to read close the connection
                    if (rc<0)
					{
						perror("Error while reading from control port");
						close(cfd);
					}

					else if (!rc) //it the administrator closed the terminal close the connection
					{
						printf("Client in the control port closed the connection unexpectfully\n");
						close(cfd);
					}

					else
					{
						control_parse=parse_c(buffer); //parse the control command
						
                    	if (control_parse==C_COUNT) // if count command
                    	{
                    		err=pthread_mutex_lock(&data_mut); 
							if (err)
							{
								perror("Error while locking the data mutex");
								abort();
							}
                    		sprintf(buffer, "%d\n", countItems());

                    		err=pthread_mutex_unlock(&data_mut); 
							if (err)
							{
								perror("Error while locking the data mutex");
								abort();
							}
                       		write(cfd, buffer, strlen(buffer));
                    	}

                    	else if (control_parse==C_SHUTDOWN) //if there is a shutdown command
                    	{
                    		printf("Message for shutdown Server\n"); 
                    		strcpy(buffer,"SHUTDOWN! Command received\n");
							write(cfd, buffer, strlen(buffer));                   	
                    		close(cfd); //close the controlo connection 
                    		pthread_mutex_lock(&mut); //protect shutdown flag
                    		shut_down=true; //shutdown flag predicate
                    		pthread_cond_broadcast(&new_conn);
                    		pthread_mutex_unlock(&mut); 
                    		break; //exit the infinite loop              	
                    	}

                    	else if (control_parse==C_ERROR) //if there is an error
                    	{
                    		strcpy(buffer,"ERROR! The command is invalid\n"); 
							write(cfd, buffer, strlen(buffer));
                    		printf("Error in control parsing\n");                    	                   	
                    	}

                    	strcpy(buffer,"Connection Closed! Goodbye!\n");
						write(cfd, buffer, strlen(buffer));
						close(cfd);	//close control connection
					}
                    
				}

				if ((pfd[1].revents & POLLIN)) //if something happened on the data port
				{
					
					dfd = accept(dsocket, (struct sockaddr *)&control, &len); //accept the connection
					if (dfd<0)
					{
						perror("Error while accepting a connection in the data port");
						abort();
					}	

					err=pthread_mutex_lock(&mut); 
					if (err)
					{
						perror("Error while locking the mutex");
						abort();
					}
					printf("We have an event in the data port! Connection: %d\n", main_counter+1);	
					client_fds[main_counter]=dfd; //put the file descriptor into the fixed-size queue
					main_counter++; //connections accepted
					if (!full) //if not NTHREADS=4 concurrently working inform the worker that there is a new connection
					{							
						connflag=true;	//connection flag predicate					
						pthread_cond_signal(&new_conn); //wake up a thread
					}
						
					err=pthread_mutex_unlock(&mut); 
					if (err)
					{
						perror("Error while unlocking the mutex");
						abort();
					}					
					
      			}
      	}
    }
    
    
     /* Wait for worker threads to finish */
    for (i = 0; i<NTHREADS; i++) 
    {
       err = pthread_join(workers[i], NULL);
	   if (err)
		{
			printf("Error while joining the worker threads\n");
			abort();
		}
    }

 	printf("SERVER IS SHUTTING DOWN\n");
    

   
	/* Destroy mutexes, condition variables and close the sockets */

    close(csocket);
    close(dsocket);

	pthread_mutex_destroy(&mut);
	pthread_mutex_destroy(&data_mut);
	pthread_cond_destroy(&new_conn);
	pthread_exit(NULL);
  
    return 0;
}


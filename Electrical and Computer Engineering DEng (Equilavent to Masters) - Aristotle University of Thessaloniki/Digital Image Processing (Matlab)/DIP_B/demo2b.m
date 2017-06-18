%Mourouzi Christos
%AEM: 7571

%% First Experiment
%Convolution between two images (NxN * NxN)
%Initialization
Nmax=50;
conv=10;
time_a=zeros(Nmax,1);
time_b=zeros(Nmax,1);
time_c=zeros(Nmax,1);

for N=1:Nmax
    % Create NxN images
    x=rand(N,N);
    y=rand(N,N);
    %Calculate time
    for i=1:conv
        %calculation with myconv2
        tic
        conv1=myconv2(x,y);
        elapsed_time_a=+ toc; % Sum the elapsed time for every loop
        
        %calculation with myconv2freq
        tic
        conv2y=myconv2freq(x,y);
        elapsed_time_b=+ toc;
        
        %calculation with conv2
        tic
        conv3=conv2(x,y);
        elapsed_time_c=+ toc;
    end
    % Calculate the average execution time 
    time_a(N)= elapsed_time_a/conv;
    time_b(N)= elapsed_time_b/conv;
    time_c(N)= elapsed_time_c/conv;
end


%First experiment' Results
N=1:Nmax;
figure; 
plot(N,time_a,'b',N,time_b,'r',N,time_c,'g')
xlabel('N')
ylabel('Average time')
legend('myconv2','myconv2freq','conv2')
title('First experiment Results')

%% Second experiment 
% Convolution between two images (NxN * 16x16)
h=rand(16,16);

for N=1:Nmax
    x=rand(N,N);
        
    for i=1:conv
        %calculation with myconv2
        tic
        conv1=myconv2(x,h);
        elapsed_time_a=+ toc;
        
        %calculation with myconv2freq
        tic
        conv2y=myconv2freq(x,h);
        elapsed_time_b=+ toc;
        
        %calculation with build-in conv2 Matlab function
        tic
        conv3=conv2(x,h);
        elapsed_time_c=+ toc;
    end
    
    %Calculate the average execution time 
    time_a(N)= elapsed_time_a/conv;
    time_b(N)= elapsed_time_b/conv;
    time_c(N)= elapsed_time_c/conv;
end

%Seecond experiment's Results
N=1:Nmax;
figure; 
plot(N,time_a,'b',N,time_b,'r',N,time_c,'g')
legend('myconv2','myconv2freq','conv2')
xlabel('N')
ylabel('Average time')
title('Seecond experiment Results')
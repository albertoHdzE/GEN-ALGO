
clear
%------------------función objetivo
fitnessFunct='modulosBin'; % objective function
numParams=2; % number of optimization variables
%_______________________________________________________
% II. Stopping criteria
maxit=200; % max number of iterations
mincost=-9999999; % minimum cost
%_______________________________________________________
% III. GA parameters
popsize=5000; % set population size
mutrate=0.1; % set mutation rate
selection=0.4; % fraction of population kept
geneLen=4; % number of bits in each parameter
NumBitsChromo=geneLen*numParams; % total number of bits in a chormosome
keep=floor(selection*popsize); % #population members that survive
%_______________________________________________________
% Create the initial population
indxGeneration=0; % generation counter initialized
population=round(rand(popsize,NumBitsChromo)); % random population of 1s and 0s
cost=modulosBin(population, geneLen);
%[cost,ind]=sort(cost);% min cost in element 1
[cost,ind]=sort(cost,'descend'); % min cost in last element
population=population(ind,:); % sorts population with lowest cost first

pop2=population;
for i=1:length(cost)
    pop2(i,9)=cost(i,1);
end

%dlmwrite('generacion.txt',pop2);
minPopulation(1)=min(cost); % minPopulation contains min of population
meanPopulation(1)=mean(cost); % meanPopulation contains mean of population
%_______________________________________________________
% Iterate through generations
while indxGeneration<maxit
    indxGeneration=indxGeneration+1; % increments generation counter
    %_______________________________________________________
    % Pair and mate
    NumMatings=ceil((popsize-keep)/2); % number of matings
    prob=flipud([1:keep]'/sum([1:keep]));% weights chromosomes based upon position in list
%     plot([1:keep],prob)
%     sumaProb=cumsum(prob(1:keep));
%     plot([1:keep],sumaProb)
    acumProb=[0 cumsum(prob(1:keep))']; % probability distribution function
    
    pick1=rand(1,NumMatings); % mate #1
    pick2=rand(1,NumMatings); % mate #2

    % ma and pa contain the indicies of the chromosomes
    % that will mate
    indexChromo=1;
    %while indexChromo<=floor(M/2)
    while indexChromo<=NumMatings
        for idx=2:keep+1
            if pick1(indexChromo)<=acumProb(idx) && pick1(indexChromo)>acumProb(idx-1)
                mum(indexChromo)=idx-1;
            end % if
            if pick2(indexChromo)<=acumProb(idx) && pick2(indexChromo)>acumProb(idx-1)
                dad(indexChromo)=idx-1;
            end % if
        end % idx
        indexChromo=indexChromo+1;
    end % while
    %_______________________________________________________
    % Performs mating using single point crossover
    idxMate=1:2:NumMatings; % index of mate #1
    crossPoint=ceil(rand(1,NumMatings)*(NumBitsChromo-1)); % crossover point M=#Mates, Nt=Long Chromosome

    sizeIndex = size(idxMate);
    % first offspring
    for i=1:sizeIndex
        population(idxMate(i),:)=[population(mum(i),1:crossPoint) population(dad(i),crossPoint+1:NumBitsChromo)];
    end
    % second offspring
    for i=1:sizeIndex
        population(idxMate(i)+1,:)=[population(dad(i),1:crossPoint) population(mum(i),crossPoint+1:NumBitsChromo)];
    end

    %_______________________________________________________
    % Mutate the population
    nmut=ceil((popsize-1)*NumBitsChromo*mutrate); % total number
    % of mutations
    mrow=ceil(rand(1,nmut)*(popsize-1))+1; % row to mutate
    mcol=ceil(rand(1,nmut)*NumBitsChromo); % column to mutate
    for ii=1:nmut
        population(mrow(ii),mcol(ii))=abs(population(mrow(ii),mcol(ii))-1);
        % toggles bits
    end % ii
    %_______________________________________________________
    % The population is re-evaluated for cost
    cost=modulosBin(population, geneLen);
    %_______________________________________________________
    % Sort the costs and associated parameters
    [cost,ind]=sort(cost,'descend');
    population=population(ind,:);
    
    %_______________________________________________________
    % Do statistics for a single nonaveraging run
    minPopulation(indxGeneration+1)=min(cost);
    meanPopulation(indxGeneration+1)=mean(cost);
    maxc(indxGeneration+1)=max(cost);
    %_______________________________________________________
    % Stopping criteria
    if indxGeneration>maxit || cost(1)<mincost
        break
    end
    [indxGeneration cost(1)]
end %indxGeneration
%_______________________________________________________
% Displays the output
day=clock;
disp(datestr(datenum(day(1),day(2),day(3),day(4),day(5),day(6)),0))
disp(['optimized function is ' fitnessFunct])
format short g
disp(['popsize = ' num2str(popsize) ' mutation rate = ' num2str(mutrate) ' # numero de variables = ' num2str(numParams)])
disp(['#generations=' num2str(indxGeneration) ' best cost=' num2str(cost(1))])
disp(['best solution'])
disp([num2str(population(1,:))]);
disp([num2str(cost(1,:))]);
disp('binary genetic algorithm')
disp(['each parameter represented by ' num2str(geneLen) ' bits'])
figure(24)
iters=0:length(minPopulation)-1;
plot(iters,minPopulation,'-.r*')
hold on
plot(iters,meanPopulation,'--mo')
hold on
plot(iters,maxc,':bs');
xlabel('generation');ylabel('cost');
%ylim([0.8 2])
%xlim([-0 10])
text(0,minPopulation(1),'best');text(1,minPopulation(2),'population average')
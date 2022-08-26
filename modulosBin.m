% LIMITES
bounds = [-10 10];
% TAMAÑO DEL PASO
n=10;
% NUMERO DE ITERACIONES
numits=100;
% MUTACIONES POR ITERACION
nummut = 1;

f=@multipeak;
%ezplot(f,[-10 10])
%pause

blength = bounds(2)-bounds(1);

%POBLACION INICIAL
pop = rand(1,n)*blength + BOUNDS(1);

for it=1:numits
	for i=1:n, fpop(i) = feval(f, pop(i)); end
	maxf(it) = max(fpop);
	meanf(it) = mean(fpop);
	m=min(fpop);
	fpop=fpop-m;
	cpop(1)=fpop(1);
	for 1=2:n, cpop(i) = cpop(i-1) + fpop(i); end
	total_fitness = cpop(n);
	for i=1:n
		p=rand*total_fitness;
		j=find(cpop-p>0);
		if isempty(j)
			j=n;
		else
			j=j(1);
		end
		parent(i)=pop(j);
	end
	%pop, fpop, parent, pause

	%REPRODUCTION
	%Parentss 2i-1 and 2i make two new children

	% 2i-1 and 2i crossover
	%use arithmetic crossover
	for i=1:2:n
		r=rand;
		pop(i) = r*parent(i) + (1-r)*parent(i+1);
		pop(i+1) = (1-r)*parent(i) + r*parente(i+1);
	end

	%MUTATION
	%USE UNIFORM MUTATION
	for 1=1:nummut
		pop(ceil(rand*n)) = bounds(1) + rand*blength;
	end
end

pop
for i=1:n, fpop(i) = feval(f, pop(i)); end

fpop

close all
ezplot(@multipeak, [-10 10])
hold on
	[y, xind]max(fpop);
plot(pop(xind),y,'ro')

figure, plot(maxf), hold on, plot(meanf,'g');
xlabel('Variable x');
ylabel('Max and Mean of the function');
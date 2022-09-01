function f=modulosBin(x, len)

    function g=evaluateGene(gene)
        if size(gene,2) == sum(gene)
            g = 2;
        end
        if size(gene,2) > sum(gene)
            g = 1;
        end
        %disp(['gene:' num2str(gene) ' size:' num2str(size(gene,2)) ' sum:' num2str(sum(gene)) ' g:' num2str(g)])
    end

    function s=splitChromoAsGenes(x, len)
        h=[];
        numElem = size(x, 2)/len;
        for i=1:numElem
            start = ((i*len)-len)+1;
            ending = (start + len) - 1;
            elem = x(start:ending);
            h(end+1, :) = elem;
        end
        s=h;
    end

    function e=evaluateChromo(x,len)
        elements = splitChromoAsGenes(x, len);
        e = 0;
        for i=1:size(elements)
            value = evaluateGene(elements(i,:));
            e = e + value;
        end
    end
    
    function p=evaluatePopulation(x, len)
        out=[];
        numChromo = size(x,1);
        for i=1:numChromo
            oneChromo = x(i,:);
            out(end+1,:)=evaluateChromo(oneChromo, len);
        end
        p=out;
    end
f=evaluatePopulation(x,len);
end
function [shortestDist, routePath] = dijkstra(netGraph, startPoint)
    totalNodes = size(netGraph, 1);
    shortestDist = inf(1, totalNodes);
    routePath = zeros(1, totalNodes);

    nodeChecked = false(1, totalNodes);
    shortestDist(startPoint) = 0;

    for idx = 1:totalNodes
        minNode = -1;
        for nodeIter = 1:totalNodes
            if ~nodeChecked(nodeIter) && (minNode == -1 || shortestDist(nodeIter) < shortestDist(minNode))
                minNode = nodeIter;
            end
        end

        nodeChecked(minNode) = true;

        for adjNode = 1:totalNodes
            if netGraph(minNode, adjNode) > 0
                potentialDist = shortestDist(minNode) + netGraph(minNode, adjNode);
                if potentialDist < shortestDist(adjNode)
                    shortestDist(adjNode) = potentialDist;
                    routePath(adjNode) = minNode;
                end
            end
        end
    end
end


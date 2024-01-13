function TT_OD = ques2(TT_link)
    node_count = size(TT_link, 1);

    TT_OD = zeros(node_count, node_count, size(TT_link, 3));

    for sample_idx = 1:size(TT_link, 3)
        current_sample_net = squeeze(TT_link(:, :, sample_idx));

        for start_node = 1:node_count
            [shortestTimes, ~] = dijkstra(current_sample_net, start_node);
            TT_OD(start_node, :, sample_idx) = shortestTimes;
        end
    end
end


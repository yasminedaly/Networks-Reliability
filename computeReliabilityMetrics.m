function [var_coeff, routeDist, skewness_coeff, ReliabilityIndex] = computeReliabilityMetrics(tt10, tt50, tt90, tt95, TT_OD)

    average_speed = 15; % Average speed in km/h
    free_flow_time = tt95; % Using 95th percentile as free flow time
    routeDist = average_speed * mean(free_flow_time / 60); % Route distance calculation

    % Compute variability coefficient (lambda_var)
    var_coeff = (tt90 - tt10) / tt50;

    % Compute skewness coefficient (lambda_skew)
    skewness_coeff = (tt90 - tt50) / (tt50 - tt10);

    % Compute Unreliability Index (UIr)
    ReliabilityIndex = var_coeff * log(skewness_coeff) / routeDist;
end


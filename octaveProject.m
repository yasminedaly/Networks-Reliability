load('C:\\Users\\Yasmine\\Downloads\\TT_link.mat');
travel_times = TT_link;
%travel_times
%disp(TT_link(1:10, 1:10))

% Get the size of the matrix
[matrix_size, ~, num_samples] = size(TT_link);

num_nodes = matrix_size;

%Display the number of nodes
%disp(['The number of nodes (bus stops) in the network is: ', num2str(num_nodes)]);

% Call the ques2 function
TT_OD = ques2(TT_link);

% Display a portion of the results for manual verification
origin_node = 1; % for example, node 1
sample_number = 1; % for example, sample 1

% Retrieve the shortest travel times from the origin to all destinations for the chosen sample
%travel_times_from_origin = TT_OD(origin_node, :, sample_number);

% Display the results
%fprintf('Shortest travel times from node %d in sample %d:\n', origin_node, sample_number);
%for destination_node = 1:numel(travel_times_from_origin)
%    if destination_node ~= origin_node % To avoid displaying the travel time from the node to itself
%        fprintf('To node %d: %6.2f minutes\n', destination_node, travel_times_from_origin(destination_node));
%    end
%end


% COV
averageTT_OD = mean(TT_OD,3);
COV = std(TT_OD, 0, 3) ./ averageTT_OD;
COV(isnan(COV)) = 0;

% Percentiles
[tt10, tt50, tt80, tt90, tt95] = percentiles(TT_OD);

% λvar, λdev and Undesirable Index of Reliability
[var_coeff, routeDist, skewness_coeff, ReliabilityIndex] = computeReliabilityMetrics(tt10, tt50, tt90, tt95, TT_OD);

% Buffer Index
BI = (tt95 - averageTT_OD) ./ averageTT_OD;

% Planning Time Index
tt_freeflow = tt95;
PTI = tt95 / tt_freeflow;

% Misery Index
TT_OD_TT80 = TT_OD > tt80;
TT_OD_filtered = TT_OD .* TT_OD_TT80;
MI = (mean(TT_OD_filtered, 3) - averageTT_OD) / averageTT_OD;

% Probability
Pr = sum(TT_OD > (0.1 + tt50), 3) / size(TT_OD, 3);



% Display COV
disp('Coefficient of Variation (COV):');
disp(COV);

% Display Percentiles
disp('Percentile Travel Times:');
fprintf('TT10: %f minutes\n', tt10);
fprintf('TT50: %f minutes\n', tt50);
fprintf('TT80: %f minutes\n', tt80);
fprintf('TT90: %f minutes\n', tt90);
fprintf('TT95: %f minutes\n', tt95);

% Display λvar, λdev and UIr
disp('Reliability Metrics:');
fprintf('Variability Coefficient (λvar): %f\n', var_coeff);
fprintf('Route Distance (Lr): %f km\n', routeDist);
fprintf('Skewness Coefficient (λskew): %f\n', skewness_coeff);
fprintf('Unreliability Index (UIr): %f\n', ReliabilityIndex);

% Display Buffer Index
disp('Buffer Index (BI):');
disp(BI);

% Display Planning Time Index
disp('Planning Time Index (PTI):');
disp(PTI);

% Display Misery Index
disp('Misery Index (MI):');
disp(MI);

% Display Probability
disp('Probability (Pr):');
disp(Pr);



% Value of Time
vot = 11.4 / 60;

% Best Benefits Calculation
best_benefits = (tt50 - min(TT_OD, [], 3)) * vot;

% Worst Benefits Calculation
worst_benefits = (tt50 - max(TT_OD, [], 3)) * vot;

% Display the results
disp('Best Time-Savings Benefits (in euros):');
disp(best_benefits);

disp('Worst Time-Savings Benefits (in euros):');
disp(worst_benefits);




function [] = RemoveBadReadings(contact_file, reading_file, output_file)
%REMOVEBADREADINGS Read the given readings file, omit rows that have poor
%contact values, and write the result to 'output_file'

contacts = dlmread(contact_file);
readings = dlmread(reading_file);

% Calculate the lower cutoff for each column of reading information
mean_vals = mean(contacts);
std_devs = std(contacts);

lower_bounds = mean_vals - std_devs;

% Iterate through all the rows in the data, appending the idx of good rows
nrows = size(contacts, 1);
final_rows = [];
for idx = 1:nrows
    if ShouldStay(contacts(idx, :), lower_bounds)
        final_rows(end + 1) = idx;
    end
end

% Allocate a final matrix of the appropriate size and add the necessary
% rows
final_matrix = zeros(length(final_rows), size(contacts, 2));
for row = 1:length(final_rows)
    final_matrix(row, :) = readings(final_rows(row), :);
end

% Write the result to file
dlmwrite(output_file, final_matrix, ' ');

end

function [flag] = ShouldStay(row, lower_bound)

diff = row - lower_bound;

flag = all(diff >= 0);

end


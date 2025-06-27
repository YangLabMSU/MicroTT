function sorted_dates = SortByDate(dates)

    % Loop through the string vector and extract dates
    for i = 1:length(dates)
    
        parts = split(dates(i), {' ', '_', 'TD '});
        first_date = datetime(parts(2), 'InputFormat', 'MM-dd-yy');
        second_date = datetime(parts(4), 'InputFormat', 'MM-dd-yy');
    
        first_dates(i,1) = first_date;
        second_dates(i,1) = second_date;
    
    end
    
    % Combine the dates into a table
    T = table(dates, first_dates, second_dates);
    
    % Sort the table by the first and then the second date
    T = sortrows(T, {'first_dates', 'second_dates'});
    
    % Display the sorted dates
    sorted_dates = T.dates ;

end

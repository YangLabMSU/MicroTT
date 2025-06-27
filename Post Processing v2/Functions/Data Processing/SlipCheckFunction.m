function SlipCheck = SlipCheckFunction(Notes)

text = Notes ; 

% Convert the text to lowercase for case-insensitive comparison
text_lower = lower(text);

% Check if the lowercase text contains "fracture"
slip_found = contains(text_lower, "slip");

if slip_found
    
  disp("The string contains the word 'slip'.");
  SlipCheck = "Slipped" ; 

else

  SlipCheck = "No Slip" ; 

  % disp("The string does not contain the word 'slip'.");

end

end
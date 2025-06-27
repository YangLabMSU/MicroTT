function FractureCheck = FractureCheckFunction(Notes)

text = Notes ; 

% Convert the text to lowercase for case-insensitive comparison
text_lower = lower(text);

% Check if the lowercase text contains "fracture"
fracture_found = contains(text_lower, "fracture");

if fracture_found
    
  disp("The string contains the word 'fracture'.");
  FractureCheck = "Fracture" ; 

else

  FractureCheck = "No Fracture" ; 

  % disp("The string does not contain the word 'fracture'.");
  
end

end
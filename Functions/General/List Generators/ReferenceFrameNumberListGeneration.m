function [ReferenceFrameNumberList] = ReferenceFrameNumberListGeneration(TotalFrames, Frames2Save)

% Frame Differential
FrameDiff = round(linspace(1,TotalFrames,Frames2Save)) ;
ReferenceFrameNumberList = [] ;
i = 1 ;

%while i <= TotalFrames
for i = FrameDiff

    ReferenceFrameNumberList = [ ReferenceFrameNumberList ; i ] ;
    
    %i = i + FrameDiff ;

end

ReferenceFrameNumberList(end) = TotalFrames-1 ;

end
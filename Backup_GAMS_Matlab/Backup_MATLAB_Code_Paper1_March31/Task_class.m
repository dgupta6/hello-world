classdef Task_class
    properties
        start
        duration
    	finish
        task
        unit
        unit_N %unit_number
        batchsize
        height
        color
    end
    
    methods
        function thisTask_class = Task_class(start,finish,task,unit,batchsize)
            if nargin==5
                thisTask_class.start=start;
                thisTask_class.duration=finish-start;
                thisTask_class.task=task;
                thisTask_class.unit=unit;
                thisTask_class.batchsize=batchsize;
            end
        end
    
        function handle=draw(thisTask_class)
%             annotation('textbox','position',[0.5 0.5 0.1 0.1],'String','hello')
        string=[char(thisTask_class.task),'/' num2str(thisTask_class.batchsize) ];
        
        handle=annotation('textbox','position',[thisTask_class.start thisTask_class.unit_N thisTask_class.duration thisTask_class.height],...
                'String',string,...
                'HorizontalAlignment','center','VerticalAlignment','middle','BackgroundColor',thisTask_class.color);
        end
    end
end

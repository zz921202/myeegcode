classdef test_class < handle
    properties(Constant)
        count = 1
    end
    methods(Static)
        function  get_count()
            
            disp(test_class.count);
        end
    end
end

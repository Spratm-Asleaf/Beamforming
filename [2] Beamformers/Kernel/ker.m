function ret = ker(x, y, params)
% kernel function - a measure to qunatify the similarity between x and y
% A Good Ref: Micchelli, C. A., Xu, Y., & Zhang, H. (2006). Universal Kernels. Journal of Machine Learning Research, 7(12).

    scale = params.scale;

    mode = upper(params.mode);
    switch mode
        case 'GAUSSIAN'
            % Gaussian kernel
            ret = exp(-scale*(norm(x - y))^2);
    
        case 'LAPLACIAN'
            % Laplacian kernel
            ret = exp(-scale*norm(x - y, 1));
    
        case 'BOOL'
            % Boolean kernel
            if norm(x - y, inf) < 1e-6
                ret = 1;
            else 
                ret = 0;
            end

        otherwise 
            error('ker :: Error in Kernel Mode :: Non-existing !');
    end
end


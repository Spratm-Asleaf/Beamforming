function vec = Steering(N, theta)
    vec = [];
    for i = 1:N
        % let d := lambda/2
        % "theta" is a column vector
        vec = [vec exp(1j*(i-1)*pi*sin(theta))];
    end

    vec= vec(:);
end
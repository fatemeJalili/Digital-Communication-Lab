function [p, t] = pulseShape(pulseName, fs, nSymbolSamples, varargin)
    Ts = nSymbolSamples/fs;
    timeStep = 1/fs;
    switch pulseName
        case 'raisedCosine'
            beta = varargin{1};
            spanInSymbols = varargin{2};

            t = -spanInSymbols*Ts/2 : timeStep : spanInSymbols*Ts/2-timeStep;
            p = sinc(t/Ts).*(cos(pi*beta*t/Ts)./(1-(2*beta*t/Ts).^2));
            nanIndices = ((beta*t/Ts).^2 == 1/4);
            p(nanIndices) = sinc(t(nanIndices)/Ts).*((pi*sin(pi*beta*t(nanIndices)/Ts))./(8*beta*t(nanIndices)/Ts));
        case 'rootRaisedCosine'
            beta = varargin{1};
            spanInSymbols = varargin{2};

            t = -spanInSymbols*Ts/2 : timeStep : spanInSymbols*Ts/2-timeStep;
            p = 1/sqrt(Ts)*(sin(pi*t*(1-beta)/Ts)+4*beta*t.*cos(pi*t*(1+beta)/Ts)/Ts)./(pi*t.*(1-(4*beta*t/Ts).^2)/Ts);
            zeroIndex = (t == 0);
            specialIndices = (t.^2 == (Ts/(4*beta)).^2);
            p(zeroIndex) = (1-beta+4*beta/pi)/sqrt(Ts);
            p(specialIndices) = beta*((1+2/pi)*sin(pi/(4*beta))+(1-2/pi)*cos(pi/(4*beta)))/sqrt(2*Ts);
        case 'gaussian'
            beta = varargin{1};
            spanInSymbols = varargin{2};

            t = -spanInSymbols*Ts/2 : timeStep : spanInSymbols*Ts/2-timeStep;
            p = (qfunc(2*pi*beta*(t-Ts/2))-qfunc(2*pi*beta*(t+Ts/2)))/log(2);
    end
    t = t.';
    p = p.';
    p = p./sqrt(p.'*p);
end
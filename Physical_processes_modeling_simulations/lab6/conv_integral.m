function integ=conv_integral(c_in, i, dt, tt, lambda, Pe, NN);
  
    
    sum=0;
    t=i*dt;    
    for j=1:i-1
     it=j;
     tau=j*dt;
     switch(NN)
     case 2
         f=c_in(it)*1/tt*exp(-(t-tau)/tt)*exp(-lambda*(t-tau));
     case 3
         f=c_in(it)*1/sqrt(4*pi*Pe*(t-tau)/tt)*1/(t-tau)*exp(-(1-(t-tau)/tt)^2/(4*Pe*(t-tau)/tt))*exp(-lambda*(t-tau));
     end        
     sum = sum + f;
    end;    
    integ=sum*dt;    

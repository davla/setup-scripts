Array.prototype.findIndex=function(n){var t;if(this===null)throw new TypeError("Array.prototype.findIndex called on null or undefined");if(typeof n!="function")throw new TypeError("predicate must be a function");var i=Object(this),u=i.length>>>0,f=arguments[1],r;for(t=0;t<u;t++)if(r=i[t],n.call(f,r,t,i))return t;return-1};

var dragonRows,resultTimes;(function(n){var u,i;resultTimes=n();var t=function(n){n=n.replace(/ /g,"");var t=CryptoJS.MD5(n).toString();return"//vignette3.wikia.nocookie.net/dragonvale/images/"+t[0]+"/"+t.substr(0,2)+"/"+n},f=["Winter","Spring","Summer","Autumn"],e=function(n){return n instanceof moment||(n=moment()),f[n.quarter()-1]},r={Snowflake:function(n,i){return t(i+"DragonAdult"+n.slice(-1)+".png")},Seasonal:function(n){return t(e(n)+"SeasonalDragonAdult.png")}};r.Monolith=r.Snowflake,u=function(i){var f=n("<td></td>",{text:i}),u=i.match(/(Seasonal|Snowflake|Monolith)/);return u=u?u[0]:i,f.prepend(n("<img />",{src:t(u+"DragonEgg.png")})),f.prepend(n("<img />",{src:r[u]?r[u](i,u):t(i+"DragonAdult.png")}))},i=function(i){if(i==null)return n("<td></td>",{text:"Nessuno"});var r=n("<td></td>",{text:i});return r.prepend(n("<img />",{src:t(i+"_Flag.png")}))},dragonRows=function(t,r){var o,e,f;if(!r.length){t.append('<tr><td colspan="6">Nessun drago trovato</td></tr>');return}for(o=0;o<r.length;++o)e=r[o],f=n("<tr></tr>"),f.append(u(e.name)),f.append(n("<td></td>",{text:e.time})),f.append(i(e.elem1)),f.append(i(e.elem2)),f.append(i(e.elem3)),f.append(i(e.elem4)),t.append(f);resultTimes=t.find("td:nth-of-type(2)")}})(jQuery);

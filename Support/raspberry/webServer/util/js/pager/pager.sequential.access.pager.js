(function(n){n.module("circMov").component("sequentialAccessPager",{controllerAs:"model",templateUrl:"/util/html/sequential-access-pager.html",bindings:{currentItem:"<",pageLength:"<",itemsCount:"<",onItemChange:"&",onPageLengthChange:"&"},controller:["CircularMovements",function(n){this.isPaginable=function(){return this.itemsCount>this.pageLength},this.rewind=function(){this.currentItem=n.moveBackByMany(this.pageLength,this.currentItem,this.itemsCount);this.onItemChange({newItem:this.currentItem});return this},this.prev=function(){this.currentItem=n.moveBackByOne(this.currentItem,this.itemsCount);this.onItemChange({newItem:this.currentItem});return this},this.next=function(){this.currentItem=n.moveForwardByOne(this.currentItem,this.itemsCount);this.onItemChange({newItem:this.currentItem});return this},this.fastForward=function(){this.currentItem=n.moveForwardByMany(this.pageLength,this.currentItem,this.itemsCount);this.onItemChange({newItem:this.currentItem});return this}}]})})(angular);

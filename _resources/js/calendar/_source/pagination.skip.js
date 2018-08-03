var Pagination = {
	init: function(obj){
		/*
		* Text fields which can be used to change Calendar language.
		* Parameters: 
		* @param maxEvents Integer - Max number of items per page
		*/
		this.maxEvents = obj.maxEvents ? obj.maxEvents : 10;
		this.data = obj.data ? obj.data : [];
		this.page = obj.page ? obj.page : 1;
		this.pages = Math.ceil(this.data.length / this.maxEvents);
		this.target = obj.target ? obj.target : {};
		this.heading = obj.heading ? obj.heading : false;
		this.list();
		this.draw();
	},
	list: function(){
		var ul    = document.createElement("ul"),
			start = (this.page - 1) * this.maxEvents,
			end   = start + this.maxEvents;
		
		
		ul.setAttribute('class', 'calendar-event list-unstyled');
		for(var i = start; i < end; i++)
			if(this.data[i]) ul.appendChild(this.data[i]);
		
		if(this.heading)
			this.target.appendChild(this.heading);
			
		if(this.data)
			this.target.appendChild(ul);
		return this.target;
	},
	clear: function(){
		if(this.target)
			while (this.target.firstChild)
				this.target.removeChild(this.target.firstChild);
	},
	draw: function(){
		var self = this;
		var ul = document.createElement("ul");
		var li, a;
		if(this.pages > 1){
			for(var i = 0; i < this.pages; i++){
				li = document.createElement("li");
				a = document.createElement("a");
				a.setAttribute("href", "#/" + "/page/" + (i + 1));
				a.appendChild(document.createTextNode(i + 1));
				//assign the event handlers for the controls
				a.addEventListener("mouseup", function( e ){
					self.page = parseInt(this.innerHTML);
					self.clear();
					self.list();
					self.draw();
				});
				a.addEventListener("keypress", function ( e ) {
					if(e.charCode == 13 || e.charCode == 32){
						self.page = parseInt(this.innerHTML);
						self.clear();
						self.list();
						self.draw();
					}
				});
				li.appendChild(a);
				if(i + 1 == this.page)
					li.setAttribute("class", "active");
			
				ul.appendChild(li);
			}
			ul.setAttribute("class", "pagination");
			this.target.appendChild(ul);
			return ul;
		}
		return false;
	}
}

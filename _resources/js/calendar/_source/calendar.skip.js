Date.prototype.dateFormat = function(format)
{		
	LZ = function(x) {return (x < 0 || x > 9 ? '' : '0') + x};
	var monthNames = new Array('January','February','March','April','May','June','July','August','September','October','November','December','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
	var DAY_NAMES = new Array('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sun','Mon','Tue','Wed','Thu','Fri','Sat');
	var result="";
	var i_format=0;
	var c="";
	var token="";
	var y=this.getFullYear().toString();
	var M=this.getMonth()+1;
	var d=this.getDate();
	var E=this.getDay();
	var H=this.getHours();
	var m=this.getMinutes();
	var s=this.getSeconds();
	var yyyy, yy, MMM, MM, dd, hh, h, mm, ss, a, A, HH, H, KK, K, kk, k;
	var value = [];
	
	value['Y'] = y.toString();
	value['y'] = y.substring(2);
	value['n'] = M;
	value['m'] = LZ(M);
	value['F'] = monthNames[M-1];
	value['M'] = monthNames[M+11];
	value['j'] = d;
	value['d'] = LZ(d);
	value['D'] = DAY_NAMES[E+7];
	value['l'] = DAY_NAMES[E];
	value['G'] = H;
	value['H'] = LZ(H);
	value['g'] = H == 0 ? 12 : (H > 12 ?  H - 12 : H);
	
	//value['h']=LZ(value['g']);
	value['h']=value['g'];
	if(H > 11){ value['a']='pm'; value['A'] = 'PM';}
	else { value['a']='am'; value['A'] = 'AM';}
	value['i']=LZ(m);
	value['s']=LZ(s);
	
	// the default date format to use - can be customized to the current locale
	format = !format ? 'm/d/Y' : format + "";
	
	//construct the result string
	while (i_format < format.length) {
		c = format.charAt(i_format);
		token="";
		while ((format.charAt(i_format)==c) && (i_format < format.length))
			token += format.charAt(i_format++);
		
		result = (value[token] != null) ? result + value[token] : result + token;
	}
	return result;
};

Number.prototype.pad = function(size) 
{
  var s = String(this);
  while (s.length < (size || 2)) s = "0" + s;
  return s;
}

var Cal = {
	init : function(obj) {
		
		if(obj){
			var heading, outputArray;
			var	findCategory = this.getDisplayCategory();
			var findDate = this.getDisplayDate();
			
			this.config(obj);
			this.monthDayCount = [31,((this.displayYearInitial - 2000) % 4 ? 28 : 29),31,30,31,30,31,31,30,31,30,31];
				
			if(this.calContainer)
				this.draw();
			
			if(this.calEvents){
				if(findDate){
					outputArray = this.events(findDate);
					heading = new Date(findDate).dateFormat("F d, Y");
					this.printEvents(this.eventsHTML(outputArray), heading);
				} else {
					this.printEvents(this.eventsHTML(this.initialEvents()), this.txtStartHeading);
				}
			}
		}
	},
	redirect : function(loc){
		loc = loc.substring(-1, 1) == "/" ? loc + "/" : loc;
		
		window.location = loc + window.location.hash;
	},
	read : function(file, callback) {
		var xobj = new XMLHttpRequest();
		
        xobj.overrideMimeType("application/json");
		xobj.open('GET', file, true);
		xobj.onreadystatechange = function () {
			if (xobj.readyState == 4 && xobj.status == "200") callback(xobj.responseText);
		};
		xobj.send(null);
	},
	config : function ( obj ) {
		this.dateCurrent = new Date();
		this.dateTracker = new Date(this.dateCurrent.getFullYear(), this.dateCurrent.getMonth(), 1);
		this.displayYearInitial = this.dateCurrent.getFullYear();
		this.displayMonthInitial = this.dateCurrent.getMonth();
		/**
		* Configurable parameters
		*/
		this.calContainer = obj.hasOwnProperty("calendar") ? obj.calendar : 0;
		this.calEvents = obj.hasOwnProperty("events") ? obj.events : 0;
		this.data = obj.hasOwnProperty("data") ? obj.data : [];
		this.eventsRedirect = obj.hasOwnProperty("eventsRedirect") ? obj.eventsRedirect : 0;
		
		/*
		* Text fields which can be used to change Calendar language.
		* Parameters: 
		* @param dayList Array - Days of the week abbreviations
		* @param monthNames Array - Months of the Year
		* @param monthUpTitle String - Text for screen reader
		* @param monthDnTitle String - Text for screen reader
		* @param noEventsMsg String - Default message if there are no events to display. 
		* @param maxEvents Integer - Max number of items per page
		* @param showEventDesc Boolean - Whether to show the description or not
		* @param eventDescLength Integer - Length of characters in the description to display before showing a Read More link.
		*/
		this.dayList = obj.dayList ? obj.dayList : ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
		this.monthNames = obj.monthNames ? obj.monthNames : ['January','February','March','April','May','June','July','August','September','October','November','December'];
		this.monthUpTitle = obj.monthUpTitle ? obj.monthUpTitle : 'Go to the next month';
		this.monthDnTitle = obj.monthDnTitle ? obj.monthDnTitle : 'Go to the previous month';
		this.noEventsMsg = obj.noEventsMsg ? obj.noEventsMsg : "No events to display";
		this.maxEvents = obj.maxEvents ? parseInt(obj.maxEvents) : 999;
		this.txtFor = obj.forText ? obj.forText : "for";
		this.txtCategory = obj.categoryText ? obj.categoryText : "category";
		this.showPagination = typeof Pagination !== 'undefined' && obj.showPagination ? obj.showPagination : false;
		this.showEventDesc = obj.showEventDesc ? this.parseBoolean(obj.showEventDesc) : true;
		this.eventDescLength = obj.eventDescLength ? parseInt(obj.eventDescLength) : false;
		/*
		* Parameters: 
		* @param eventStartHeading String - The heading to display in the events when the calendar first loads
		* @param eventStartDate Date - Initial Events Start Date (should be either the default Date or the first day of the current month).
		* @param eventNumberOfDays Integer - Initial Number of Events to Display.  The default is 7.
		* @param showHeading Boolean - Whether to show or hide the events heading.
		*/
		this.showHeading = obj.showHeading ? this.parseBoolean(obj.showHeading) : true;
		this.txtStartHeading = obj.eventStartHeading ? obj.eventStartHeading : "Upcoming Events";
		this.dateStartEvents = (obj.eventStartDate && !isNaN(obj.eventStartDate.getTime())) 
			? (obj.eventStartDate ? obj.eventStartDate : new Date())
			: new Date();
		this.intNumDays = obj.eventNumberOfDays ? parseInt(obj.eventNumberOfDays) : 7;
	},
	draw : function () {
		var tbody, tr, td;
		
		this.calendar = document.createElement('div');
		this.calendar.setAttribute('id', 'simple_calendar');
		this.calendar.setAttribute('class', 'calendar');
		
		//create the calendar Day Cells
		this.calCellContainer = document.createElement('div');
		this.calCellContainer.setAttribute('class', 'calendar-display');
		this.calCellContainer.appendChild(this.days());
		
		//create the Main Calendar Heading and Day Heading
		this.calendar.appendChild(this.controls());
		this.calendar.appendChild(this.calCellContainer);
		
		if(this.calContainer)
			this.calContainer.appendChild(this.calendar);
	},
	newEvent : function(data, stdt, endt){
		return {
			title : data.title,
			description : data.description,
			author : data.author,
			category : data.category,
			link : data.link,
			image : data.image,
			pubDate : stdt,
			endDate : endt
		};
	},
	categories : function(category, sDate) {
		// events is a JSON object from an external file
		var totalEvents = [],
			dPlus = this.dateStartEvents,
			filterEvents = this.data,
			cd = sDate.dateFormat("Y-m-d"),
			dateLimit = "";
		
		dPlus.setDate(dPlus.getDate() + this.intNumDays);
		dateLimit = dPlus.dateFormat("Y-m-d");
		
		// loop through events for each date
		for(var i in this.data){
			var stdt = Number.isInteger(this.data[i].pubDate) ? new Date(this.data[i].pubDate * 1000) : new Date(this.data[i].pubDate),
				endt = (this.data[i] && this.data[i].hasOwnProperty("endDate") && this.data[i].endDate != null) 
				? (Number.isInteger(this.data[i].pubDate) ? new Date(this.data[i].endDate * 1000) : new Date(this.data[i].endDate)) 
				: null,
				st = stdt.dateFormat("Y-m-d"),
				ed = (endt) ? endt.dateFormat("Y-m-d") : null;
				
			for(var j in this.data[i].category)
				if ((this.data[i].category[j] == category) && ((st >= cd && st <= dateLimit) || (ed >= cd && ed <= dateLimit)) )
					totalEvents.push(this.newEvent(this.data[i], stdt, endt));
		}
		return (totalEvents.length) ? {	events : totalEvents } : 0;
	},
	controls : function() {
		var self = this,
			container = document.createElement('div'),
			monthDn = document.createElement('button'), 
			monthUp = document.createElement('button'),
			larrow = document.createElement('span'),
			rarrow = document.createElement('span'),
			mhead = document.createTextNode(this.monthNames[this.displayMonthInitial] + " " + this.displayYearInitial);
		
		this.ymDisplay = document.createElement('span');
		this.ymDisplay.appendChild(mhead);
		this.ymDisplay.setAttribute('id', 'calendar-monthyear-title');
		this.ymDisplay.setAttribute('tabindex', '0');
		this.ymDisplay.setAttribute('aria-label', 'Current Month');
	
		// Previous Month
		larrow = document.createElement('span');
		larrow.setAttribute('aria-hidden', 'true');
		larrow.setAttribute('class', 'glyphicon glyphicon-triangle-left');
		monthDn.setAttribute('type','button');
		monthDn.setAttribute('title',this.monthDnTitle);
		monthDn.setAttribute('class', 'btn btn-default prev-month');
		monthDn.setAttribute('aria-label', 'Previous Month');
		monthDn.appendChild(larrow);	
	
		// Next Month
		rarrow.setAttribute('aria-hidden', 'true');
		rarrow.setAttribute('class', 'glyphicon glyphicon-triangle-right');
		monthUp.setAttribute('type','button');
		monthUp.setAttribute('title',this.monthUpTitle);
		monthUp.setAttribute('class', 'btn btn-default next-month');
		monthUp.setAttribute('aria-label', 'Next Month');
		monthUp.appendChild(rarrow);
	
		//assign the event handlers for the controls
		monthUp.addEventListener("mouseup", function( e ){
			self.dateTracker.setMonth(self.dateTracker.getMonth() + 1); 
			self.setMonth();
		});
		//assign the event handlers for the controls
		monthDn.addEventListener("mouseup", function( e ){
			self.dateTracker.setMonth(self.dateTracker.getMonth() - 1); 
			self.setMonth();
		});
		//assign the event handlers for the controls
		monthUp.addEventListener("keypress", function( e ) {
			if(e.charCode == 13 || e.charCode == 32){
				self.dateTracker.setMonth(self.dateTracker.getMonth() + 1); 
				self.setMonth();
			}
		});
		monthDn.addEventListener("keypress", function ( e ) {
			if(e.charCode == 13 || e.charCode == 32){
				self.dateTracker.setMonth(self.dateTracker.getMonth() - 1); 
				self.setMonth();
			}
		});
		
		container.setAttribute("class", "mainheading");
		container.appendChild(monthDn);
		container.appendChild(this.ymDisplay);
		container.appendChild(monthUp);
	
		return container;
	},
	days : function(category){
		var self = this;
		var tbody, tr, td;
		var beginDate = new Date(this.dateTracker.getFullYear(), this.dateTracker.getMonth(), 1);
		var sdt = new Date( beginDate );
		var caption = document.createElement('caption');
		var event;
		var subDays = 0 - beginDate.getDay();
		var currMonth = this.dateTracker.getMonth();
		var tdClass = "curr";
		var today = new Date();
		
		//create the table element
		this.calCells = document.createElement('table');
		this.calCells.setAttribute('id',this.name+'_calcells');
		this.calCells.setAttribute("class", 'table calendar-table table-bordered calcells');
	
		sdt.setDate(sdt.getDate() + (subDays) - (subDays > 0 ? 7 : 0) );
		
		tbody = document.createElement('tbody');
		tr = document.createElement('tr');
		//populate the day titles
		for(var dow = 0; dow < 7; dow++){
			td = document.createElement('th');
			td.appendChild(document.createTextNode(this.dayList[dow]));
			tr.appendChild(td);
		}
		tbody.appendChild(tr);
		
		for( var i = 0; i < 42; i++ ){
			if( i % 7 == 0 )
				tr = document.createElement('tr');
			
			//create the day cells
			td = document.createElement('td');
			tdClass = sdt.getMonth() < currMonth ? "prev" : (sdt.getMonth() > currMonth ? "next" : "curr");
			td.setAttribute("class", sdt.dateFormat("Ymd") == today.dateFormat("Ymd") ? "today" : tdClass);
			
			event = this.events(sdt);
			if(event){
				var elink = document.createElement('a');
				
				elink.setAttribute("id", event.id);
				elink.setAttribute("href", event.link);
				elink.setAttribute("data-display", event.YYYYMMDD);
				elink.appendChild(document.createTextNode(event.text));
				elink.addEventListener("click", function(e){
					var displayDate = new Date(this.getAttribute("data-display"));
					var outputArray = self.events(displayDate);
					var heading = new Date(displayDate).dateFormat("F d, Y");
					
					if(self.eventsRedirect) { 
						e.preventDefault();
						var newLoc = self.eventsRedirect + this.getAttribute("href").replace(".", "");
						window.location = newLoc.replace("//", "/");
					} else {
						self.calEvents.removeChild(self.calEvents.firstChild);
						self.printEvents(self.eventsHTML(outputArray), heading);
						document.getElementById("calendar-displayed-anchor").focus();
						e.preventDefault();
					}
						
					return false;
				});	
			
				td.appendChild(elink);
			} else {
				td.appendChild(document.createTextNode(sdt.getDate()));
			}
		
			sdt.setDate(sdt.getDate() + 1); //increment the date
			tr.appendChild(td);
			tbody.appendChild(tr);
		}
	
		this.calCells.appendChild(tbody);
		return this.calCells;
	},
	deleteCells : function (){
		this.calCellContainer.removeChild(this.calCellContainer.firstChild);
	},
	events : function(date) {
		// events is a JSON object from an external file
		var self = this;
		var totalEvents = [];
		var cd = date.dateFormat("Y-m-d");
		
		

		for(var i in this.data){
			var stdt = Number.isInteger(this.data[i].pubDate) ? new Date(this.data[i].pubDate * 1000) : new Date(this.data[i].pubDate),
				endt = (this.data[i] && this.data[i].hasOwnProperty("endDate") && this.data[i].endDate != null) 
				? (Number.isInteger(this.data[i].pubDate) ? new Date(this.data[i].endDate * 1000) : new Date(this.data[i].endDate)) 
				: null,
				st = stdt.dateFormat("Y-m-d"),
				ed = (endt) ? endt.dateFormat("Y-m-d") : null;
				
			if (cd == st || (ed && (st <= cd && cd <= ed)))
				totalEvents.push(this.newEvent(this.data[i], stdt, endt));
		}
		
		return (totalEvents.length) ? {
			id : "day-" + date.dateFormat("Y/m/d"),
			link : "#/" + date.getFullYear() + '/' + ( date.getMonth() + 1 ) + '/' + date.getDate(),
			text : date.getDate(),
			YYYYMMDD : date.dateFormat("Y/m/d"),
			events : totalEvents
		} : 0;
	},
	eventsHTML : function(outputArray){
		var self = this;
		var output = [];
		var ul = document.createElement('ul');
		
		if(!outputArray.events){
			var div = document.createElement('div');
			var h3 = document.createElement('h3');
			
			h3.appendChild(document.createTextNode(this.noEventsMsg));
			div.appendChild(h3);
			output.push(div);
			return output;
		}
		
		// Display the events
		for(i in outputArray.events){
			var pubDate = outputArray.events[i].pubDate;
			var endOut = "";
			
			if(outputArray.events[i].endDate && outputArray.events[i].endDate != null){
				var endDate = outputArray.events[i].endDate;
				var edformat = endDate.dateFormat("Y-m-d") == pubDate.dateFormat("Y-m-d") ? "h:i a" : "F d, Y h:i a";
			
				endOut += " - " + endDate.dateFormat(edformat);
			}

			var li = document.createElement('li');
			var h4 = document.createElement('h4');
			var p = document.createElement('p');
			var a = document.createElement('a');
			var b = document.createElement('strong');
			
			
			a.setAttribute('href', outputArray.events[i].link);
			a.appendChild(document.createTextNode(outputArray.events[i].title));
			h4.appendChild(a);
			
			b.appendChild(document.createTextNode(pubDate.dateFormat("F d, Y h:i a") + endOut));
			li.appendChild(h4);
			li.appendChild(b);
			
			if(this.showEventDesc){
				var readmore = document.createElement('a');
				readmore.setAttribute('href', outputArray.events[i].link);
				readmore.appendChild(document.createElement('br'));
				readmore.appendChild(document.createTextNode("Read more"));
				
				var evtdesc = (this.eventDescLength) 
					? this.shortenString(outputArray.events[i].description, this.eventDescLength) 
					: outputArray.events[i].description;
					
				p.appendChild(document.createTextNode(evtdesc));
				if(Boolean(this.eventDescLength))
					p.appendChild(readmore);
					
				li.appendChild(p);
			}
			
			if(outputArray.events[i].category){
				catBox = document.createElement("p");
				catBox.setAttribute('class', 'calendar-event-category');
				
				for(var j in outputArray.events[i].category){
					var cat = document.createElement('a');
					cat.setAttribute('role', 'button');
					cat.setAttribute('class', 'btn btn-primary btn-sm');
					cat.setAttribute("href", "#/category/" + outputArray.events[i].category[j]);
					cat.setAttribute("data-fromDate" , outputArray.events[i].pubDate);
					cat.appendChild(document.createTextNode(outputArray.events[i].category[j]));
					cat.addEventListener("click", function (e) {
						//var selCat = self.getDisplayCategory(this.getAttribute("href"));
						if(self.eventsRedirect) {
							var newLoc = self.eventsRedirect + this.getAttribute("href").replace(".", "");
							window.location = newLoc.replace("//", "/");
						} else {
							var catDate = new Date(this.getAttribute("data-fromDate"));
							self.calEvents.removeChild(self.calEvents.firstChild);
							self.printEvents(self.eventsHTML(self.categories(this.innerHTML, catDate)), self.txtStartHeading + " " + self.txtFor + " " + self.txtCategory + ": " + this.innerHTML);
							document.getElementById("calendar-displayed-anchor").focus();
						}
						e.preventDefault();
					});
					catBox.appendChild(cat);
					catBox.appendChild(document.createTextNode(" "));
				}
			}
			li.appendChild(catBox);
			
			output[i] = li;
		}
		return output;
	},
	getDisplayCategory : function(url){
		// Return the category from the URL
		var regex = /\/category\/([\w]+)[^\/]?/;
		findCategory = (url) ? url.match(regex) : this.getURLHash().match(regex);
		
		return findCategory ? findCategory[1] : 0;
	},
	getDisplayDate : function(str){
		// Return the date part from the URL as a new Date()
		var regex = /\d{4,4}\/\d{1,}\/\d{1,}/;
		var findDate = !str ? this.getURLHash().match(regex) : str.match(regex);
		
		return findDate ? new Date(findDate) : 0;
	},
	getURLHash : function(){
		// Get everything in the URL after "#/"
		return window.location.hash ? window.location.hash.match(/#\/(.*)/)[1] : "";
	},
	initialEvents : function() {
		var totalEvents = [],
			dPlus = this.dateStartEvents,
			cd = this.dateStartEvents.dateFormat("Y-m-d"),
			dateLimit = "";
		
		dPlus.setDate(dPlus.getDate() + this.intNumDays);
		dateLimit = dPlus.dateFormat("Y-m-d");
		
		// loop through events for each date
		for(var i in this.data){
			var stdt = Number.isInteger(this.data[i].pubDate) ? new Date(this.data[i].pubDate * 1000) : new Date(this.data[i].pubDate),
				endt = (this.data[i] && this.data[i].hasOwnProperty("endDate") && this.data[i].endDate != null) 
				? (Number.isInteger(this.data[i].pubDate) ? new Date(this.data[i].endDate * 1000) : new Date(this.data[i].endDate)) 
				: null,
				st = stdt.dateFormat("Y-m-d"),
				ed = (endt) ? endt.dateFormat("Y-m-d") : null;
			
			if ((st >= cd && st <= dateLimit) || (ed >= cd && ed <= dateLimit))
				totalEvents.push(this.newEvent(this.data[i], stdt, endt));
		}
		return (totalEvents.length) ? {	events : totalEvents } : 0;
	},
	pagination : function(head, output){
		var container = document.createElement("div");
		container.setAttribute("id", "calendar-pagination");
		Pagination.init({
			heading : head,
			data : output, 
			maxEvents : this.maxEvents,
			target : container
		});
		
		this.calEvents.appendChild(Pagination.target);
	},
	parseBoolean : function(val){
		return val === true || val === "true"
	},
	printEvents : function(output, heading) {
		var html = "",
			ul = document.createElement("ul"),
			head = document.createElement("h3"),
			ankr = document.createElement("a");
		
		ul.setAttribute('class', 'calendar-event list-unstyled');
		ankr.appendChild(document.createTextNode(heading));
		ankr.setAttribute("id", "calendar-displayed-anchor");
		ankr.setAttribute("href", "./#/");
		ankr.setAttribute("aria-label", heading == this.txtStartHeading ? heading : this.txtStartHeading + " " + this.textFor + " " + heading);
		head.setAttribute("id", "calendar-displayed-heading");
		head.appendChild(ankr);
		
		// Clear the output box
		if(this.calEvents){
			if(this.showPagination){
				
				this.pagination(this.showHeading ? head : false, output);	
			} else {
				while (this.calEvents.firstChild)
					this.calEvents.removeChild(this.calEvents.firstChild);

				for(var i = 0; i < output.length && i < this.maxEvents; i++)
					if(output[i]) ul.appendChild(output[i]);
				
				if(this.showHeading)
					this.calEvents.appendChild(head);
					
				this.calEvents.appendChild(ul);
			}
		}
	},
	setMonth : function(date) {
		this.ymDisplay.innerHTML = this.monthNames[parseInt(this.dateTracker.getMonth())] + " " + this.dateTracker.getFullYear();
		this.ymDisplay.focus();
		this.deleteCells();
		this.calCellContainer.appendChild(this.days());
	},
	shortenString : function(str, n) {
		var tstr = str.substr(0, n);
		return tstr.substr(0, Math.min(tstr.length, tstr.lastIndexOf(" "))) + '...';
		
	}
};
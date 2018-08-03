# Admin Install Guide

## Initial Considerations/Setup
1. Determine which type of main navigation and page specific navigation you want for your site.
2. Upload files from the Template you choose into /. You can upload the zip file unzipped with the option in the upload menu.

## Site Configuration (Setup > Sites)

### Global Variables
1. Hover over your website's name
2. Select Edit > Site Access
3. Recursive Modification: Select "Apply Selected Settings to All Existing Files and Folders in the Site"
   - Access Group: (site group name)
   - URL Type: Root-Relative
4. Under RSS Feeds (If you are using RSS feeds)
   - [/_resources/news](/_resources/news)
5. Under Directory Variables:
   - Click the Add button.
   - Change Publish, Default Image Folder and Default Media Folder
   - Publish: skip:xsl,tcf,tmpl,.skip.py,.skip.js
   - Default Image Folder: [/_resources/images](/_resources/images)
   - Default Media Folder: [/_resources/images/media](/_resources/images/media)

### Recursively set the following files/directories to "Administrators Only"
- .htaccess
- robots.txt
- [/_resources/templates](/_resources/templates)
- [/_resources/ou](/_resources/ou)
- [/_resources/php](/_resources/php)

### Groups (Setup > Groups)
- Create a group and name it the same as the site name. Refer to this below as (site group name).
- Do a global find and replace under Content > Find and Replace
  1. Find: group="Template2"
  2. Replace With: group="(site group name)"
  3. Click the Preview Replace button

### Delete the following files
Go to the Production Server via Content > Pages and clicking on the Production button beside Staging (default):
- index.htm
- missing.html
- data/
- logs/
- cgi-bin/
- scripts/

### Publish the following files
- robots.txt
- .htaccess file
- /_resources folder
- index.pcf

### Adding Gadgets to your site
You should install the Bookmarks and Notes gadgets, as these are helpful for documentation and for quick finding of important links.
1. In the top menu select Add-Ons > Marketplace.
2. In the web page that displays there is a Categories menu at the top. Select Gadgets.
3. Install all the gadgets you want available on your site.
4. In the top menu select Setup > Gadgets
5. You can edit individual gadgets here.
6. You can add your own gadgets if you wish.  Here are some tutorials:
   - [https://developers.omniupdate.com/](https://developers.omniupdate.com/)
   - [https://eits.uga.edu/protected/oudocs/gadgets/index.html](https://eits.uga.edu/protected/oudocs/gadgets/index.html)
7. A helpful custom Gadget is the Check-In Gadget
   - Select Setup > Gadgets
   - Click the green + New button
   - Paste https://eits.uga.edu/_resources/gadgets/gadget-check-in/ in the text box
   - Configure the properties based on whom you want to be able to use it.

### Site Menu Gadget
1. Go to Content > Assets
2. Click the + New button
- Type: Web Content or Plain Text
- Name: Auto Publish Menus
- Asset Content: leave blank

   
### Site Nav
1. Open the Bookmarks Gadget by clicking the Plug Icon underneath the top Setup menu and site name.
2. Create an asset



## Additional Modules
The following are optional enhancements to the basic site.

### News
Additional steps are needed when creating news sections. Once you complete these steps you may add items to the section.
1. Create a News RSS Feed
   - In the top menu select Content > RSS
   - Click the + New button
   - Path: [/_resources/rss/news.xml](/_resources/rss/news.xml)
   - Enter a Title and Description
   - Link: Enter the production url for this site followed by [/_resources/rss/news.xml](/_resources/rss/news.xml)
   - Item Count: Enter 9999
2. Create a News Section
   - In the top menu select Content > Pages
   - Click the + New button and select News Section
   - Enter the information in the form and make sure the RSS feed is set to [/_resources/rss/news.xml](/_resources/rss/news.xml)
     This will create several files.  The index.pcf file will have an RSS feed associated with it.
     
     To associate the [/_resources/rss/news.xml](/_resources/rss/news.xml) with the items that you create in this section do the following:
   	 - Browse out to the parent directory
   	 - Hover over the directory name with the mouse.
   	 - An Edit, Publish, File menu will show up under the Options column in the file listing.
   	 - Hover over the Edit menu that becomes visible.
   	 - This will display another menu.  Click Access
   	 - Scroll down to RSS Feed on the modal window that pops up.  
   	 - Select the [/_resources/rss/news.xml](/_resources/rss/news.xml) feed.
   	 - Click Save.   	 

### Faculty/Staff/Student Directory
If you want a faculty/staff/student directory, you need to create a directory feed and a directory section.

The Directory uses page tagging extensively.  Each index.pcf will that you associate a tag such as faculty, staff, student etc. will show a listing of that category. This index.pcf must be republished when adding or removing people.
1. Create a Directory Feed
   - In the top menu select Content > RSS
   - Click the + New button
   - Path: [/_resources/rss/directory.xml](/_resources/rss/directory.xml)
   - Enter a Title and Description
   - Item Count: Enter 9999	
2. Create a Directory/Faculty & Staff Directory Section
   - In the top menu select Content > Pages
   - Click the + New button and select either Directory Section or Faculty & Staff Directory Section
   - Listing Category: Applies tags to the page based on this field.
   - Enter the information in the form and make sure the RSS feed is set to [/_resources/rss/directory.xml](/_resources/rss/directory.xml)
   - The categories to be displayed on the index.pcf file are set by OU tags.  This means that they are displayable anywhere on the site simply be referencing the tag that the page was created with.
4. Create groups for faculty, staff, students and whoever else you will need to access the pages and do updates in this directory.
5. The default group name for the Directory Sections is "Faculty". You can replace these by doing a global Find/Replace and change  group="Faculty" to group="whatever group".  You can restrict the Find/Replace to only do this for certain directories or files.   	

### Calendar/Calendar Events
Both the Calendar and Events can share the same feed if you desire.  If you want them to share the same feed, you will need to change the default path in [/_resources/ou/templates/events/event.tcf](/_resources/ou/templates/events/event.tcf) to the same feed used by the Calendar
1. Create an Events Feed
   - Click the + New button
   - Path: [/_resources/rss/events.xml](/_resources/rss/events.xml)
   - Enter a Title and Description
   - Link: Enter the production url for this site followed by [/_resources/rss/events.xml](/_resources/rss/events.xml)
   - Item Count: Enter 9999

2. Calendar Events (you may need to make separate assets for both the Events with Calendar and the Events without Calendar).
   * This asset can be either displayed stand alone (in which case it requires a feed attribute), or with a Calendar asset.
   * Required attributes when used as a stand-alone calendar are: feed
   * To make the Events stand alone, add a feed attribute.  If the Events will be displayed on the same page as a Calendar asset do not provide a feed.

   Type: Source Code
   Asset Content (normal Events):
   ```
   <calendar-events/> 
   ```

   Asset Content (stand alone Events):
   ```
   <calendar-events-only 
   feed="http://status.uga.edu/rss/feed.xml" 
   maxEvents="5" 
   eventNumberOfDays="12" 
   showPagination="true" 
   eventDescLength="100" 
   showHeading="false" />
   ```
   
3. Calendar (you may need to make separate assets for both the Calendar and the Calendar (stand alone).
   * See  [/_resources/js/calendar/ReadMe.html](/_resources/js/calendar/ReadMe.html) for documentation on this asset.
   * Can be created to be either stand-alone or accompanied by the Events asset.
   * Required attributes for the calendar are: feed
   * To make the calendar a stand alone calendar, give it a relative eventsRedirect URL (such as eventsRedirect="/about/calendar/").
  
   Parameters:
   - feed: Either an absolute or relative URL.  
  	 * Can also take a 'sort' parameter which is either the value 'asc' or 'desc'. The default is 'asc' if no parameter is given.
	  
   Type: Source Code
   Asset Content (normal calendar): 
	  
   ```
   <calendar 
  	 feed="(enter the calendar feed URL)" 
  	 maxEvents="5" 
  	 eventNumberOfDays="12" />
   ```
	  
   Asset Content (stand alone calendar):  
   ```
   <calendar-only 
  	 feed="(Enter the calendar feed root-relative or absolute URL)[&sort=asc|desc]" 
  	 maxEvents="5" 
  	 eventNumberOfDays="12" 
  	 eventsRedirect="/about/calendar/" />
   ```
	  

### Google Map
1. Go to [https://developers.google.com/maps/documentation/javascript/get-api-key](https://developers.google.com/maps/documentation/javascript/get-api-key)
2. Register for an API key.  Copy the API Key for use in the creating the asset.
3. Go to https://maps.google.com and enter the Street Address for the map you want to show.
4. You will see a map and in the URL an address similar to this: 
   ```
   https://www.google.com/maps/place/101+Cedar+St,+Athens,+GA+30602/@33.9451511,-83.3739854,17z/data=!3m1!4b1!4m5!3m4!1s0x88f66ce44e34ce13:0x46140e17cd38f0f0!8m2!3d33.9451467!4d-83.3717914
   ```
5. Copy the latitude and longitude from the URL. It should look like 33.9451511,-83.3739854.
6. Create a new Asset with the following settings:
   Type: Source Code
   Name: Google Map
   Description: Simple Google Map. Requires an api-key attribute.
   Asset Content:
   ```
   <google-static-map center="( Enter the Street Address )"
      api-key="( Enter API KEy )"
      size="450x450" 
      zoom="14" 
      marker="color:red;label:E;latlng:(Enter the Latitude and Longitude);size:small" 
      description="( Enter the map description )" />
   ```

### News Section Setup
Additional steps are needed when creating news sections. Once you complete these steps you may add items to the section.
1. Create the News feed
   - Click the + New button
   - Path: [/_resources/rss/news.xml](/_resources/rss/news.xml)
   - Enter a Title and Description
   - Link: Enter the production url for this site followed by [/_resources/rss/news.xml](/_resources/rss/news.xml)
   - Item Count: Enter 9999
2. Create the News section via the + New button
   - The default RSS feed should be the one you set up in step one.
   - Enter the information into the modal.  Pagination will display pagination links if the number of items in the feed exceeds the RSS Limit.
3. Select Content > Pages and browse to the parent directory.
4. In the list of files, hover the mouse over the News Section row that you just created.
5. An Edit, Publish and File menu will appear.  Select Edit > Access.
6. Under the RSS option, select the RSS feed that will be for items in this section.
   - The purpose of this is to associate the RSS Feed [/_resources/rss/news.xml](/_resources/rss/news.xml) with News Items that you add to this section.
   
#### Adding News Items to a News Section
1. Within the News Section click the + New button.
2. Enter the information requested in the modal window.
3. If you have a faculty/staff/student that this news article was written by or mentions you may tag them here.
   - Tagging people has the effect of showing up articles that they wrote within their profile page in the Faculty/Staff/Student Directory
4. 


### Other Assets (Content > Assets)

#### Publish Site Menu
- Type: Web Content or Plain Text
- Name: Auto Publish Menus
- Asset Content: leave blank

	  
#### News
- Type: Source Code
- Asset Content: 
  ```
  <rss-feed feed="https://eits.uga.edu/rss/news.xml" 
	  description="false"
	  dates="true"
	  dateFormat="D F j, Y"
	  limit="10"
	  pagination="true"/>
  ```
  
- Properties:
  - feed (required): string - Either a relative (begins with a slash) or 
  - description: boolean - show or hide description from RSS 
  - dates: boolean - show or hide dates
  - dateFormat: string - PHP date format
  - limit: int -  number of items to show per page
  - pagination: boolean - show or hide pagination links	

## Snippets (Content > Snippets)
- Bootstrap 
  Name: Accordion Menu
  File: [/_resources/snippets/ouaccordion-table.html](/_resources/snippets/ouaccordion-table.html)

  Name: Jumbotron
  File: [/_resources/snippets/jumbotron.html](/_resources/snippets/jumbotron.html)

- Images
  Name: Image with Caption
  File: [/_resources/snippets/caption-image.html](/_resources/snippets/caption-image.html)

- Table Transformations
  Name: 3x3 Section Grid
  File: [/_resources/snippets/section-link-table-3x3.html](/_resources/snippets/section-link-table-3x3.html)

  Name: Arrow Tabs
  File: [/_resources/snippets/arrow-tabs.html](/_resources/snippets/arrow-tabs.html)

	  
### Contact/Email Form
- Edit [/_resources/php/email.php](/_resources/php/email.php).
- Change $sendto PHP variable to your department's email.
- Change $subject PHP variable to the text you would like in the subject line for emails.
- Publish [/_resources/php/email.php](/_resources/php/email.php).
- Create an Asset
  Name: Contact Form
  Type: Source Code
  Asset Content:
  ```
  <contact-us>
	<form name="sentMessage" class="well" id="contactForm">
		<legend class="sr-only">Contact Us</legend>
		<div class="control-group">
			<div class="controls">
				<input type="text" class="form-control" placeholder="Full Name" id="name" required="true" data-validation-required="required" message="Please enter your name"/><p class="help-block"></p>
			</div>
		</div>
		<div class="control-group">
			<div class="controls"><input type="email" class="form-control" placeholder="Email" id="email" required="true" data-validation-required="required" message="Please enter your email"/></div>
		</div>
		<div class="control-group">
			<div class="controls">
				<textarea rows="10" cols="100" class="form-control" placeholder="Message" id="message" required="true" data-validation-required="required" message="Please enter your message" minlength="5" data-validation-minlength-message="Min 5 characters" maxlength="999" style="resize:none"></textarea>
			</div>
		</div>
		<div id="success">&nbsp;</div>
		<button type="submit" class="btn btn-primary pull-right">Send</button><br/>
	 </form>
   </contact-us>
   ```
- Create an Interior Page from the Content > Pages menu and click the + New button
- Select Interior Page
- Name your page and edit the contents, adding the Contact Form asset.

				
## Enable Image Galleries
- Go to Setup > Sites.
- Click on the site name.
- Scroll down to LDP Settings
- Enter 209.212.159.209 in the LDP Admin Host box
- Enter /.ldp in the LDP Gallery Directory box
- Click the Save button.

## Other
* If you need OU Forms on your site, go to Setup > Sites. Click on the site name.  
Scroll down to LDP Settings. Click the Download Reg File button.  
Copy the contents of this file and create a ticket with TeamDynamix for EITS Websites 
and paste this text in the ticket with the request "Add site to OU LDP".


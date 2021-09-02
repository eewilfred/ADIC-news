# ADIC-news
NY times most viewed news listing application


## Architecture Of The app:

**I am following the MVVM-P pattern where we have**

Model -> that holds data (in this case from network operations)
View / View Controller -> that's the canvas and the binder for all elements
View model -> that hold business logic including control on network connections and custodian of Model
Presentation Layer -> which converts Data in the models from the View model to suit the Views need.
Reason For going with this approach: The application can be made easier to maintain in the long go especially when UI changes happen Business Logics can be kept hidden from UI changes thanks to the presentation layer. VC can be kept to control the Views rather than making Business logic as the View model does it.

We have a Network Manager, using URL sessions. This is kept separate for reusability accounts
A image downloader Extenstion with NSCache is added to speed up view

## UI
### NewsListingViewController:
Then Root view controller of the app is responsible for showing contents.
NewsListingViewController has NewsListingViewModel, which has all business and network requesting logic.
NewsListingPresentation, contains the view update and data translation to UI code.

### FilterView:
FilterView is a UIView inside NewsListingViewController but code seprated, it communicate with NewsListingViewController via FilterViewDelegate.
FilterView has FilterViewPresentation that formats data for showing in UI from one we obtain from NewsListingViewModel.

### NewsListingTableViewCell:
NewsListingTableViewCell is the UI element to show the news information in a table view. its presentation NewsListingCellPresentation, which is hashable also  serves as data for Diffable data source for table view 

### SEARCH FEATURES:
search is done on for the title of news.

#### FILTER:

The filter is enabled in three levels, based on 
Type,
Location information, 
Published Date

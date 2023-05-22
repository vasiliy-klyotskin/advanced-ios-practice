
# Pokepedia

## Simple app to practice TDD and modular design



## Abstract Usecases



### Load Model From Network

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Model From Network" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates Model instance from valid data.
5. System delivers Model.

#### Cancel course:
1. System does not deliver JSON nor error.

#### Invalid data – error course (sad path):
1. System delivers error.

#### No connectivity – error course (sad path):
1. System delivers error.



### Load Image Data From Network

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Image Data" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System delivers image data.

#### Cancel course:
1. System does not deliver image data nor error.

#### Invalid data – error course (sad path):
1. System delivers error.

#### No connectivity – error course (sad path):
1. System delivers error.



### Load Model From Cache

#### Data:
- Key

#### Primary course (happy path):
1. Execute "Load Model From Cache" command with above data.
2. System loads data from the cache.
3. System validstes cache is less than X days old.
4. System creates model from valid data.
5. System delivers model.

#### Cache expired – error course (sad path):
1. System delivers error.

#### Retrieving error – error course (sad path):
1. System delivers error.

#### Empty cache course (sad path): 
1. System delivers error.



### Save Model To Cache

#### Data:
- Key, Model

#### Primary course (happy path):
1. Execute "Save Model To Cache" command with above data.
2. System deletes old cache data.
3. System encodes model.
4. System timestamps the new cache.
5. System saves new cache data.



### Validate Cache Use Case

#### Primary course:
1. Execute "Validate Cache" command with above data.
2. System retrieves data from cache.
3. System validates cache is less than X days old.

#### Retrieving error – error course (sad path):
1. System delivers error.

#### Empty cache course (sad path): 
1. System does nothing.



### Present Loading Resource Use Case

#### Data:
- Resource

#### Primary courses:
1a. Execute "Start Loading" command.
2a. System hides error.
3a. System starts loading.

1a. Execute "End With Error" command.
2a. System finishes loading.
3a. System shows general error with above message.

1a. Execute "End With Resource" command with Resource data.
2a. System finishes loading.
3a. System shows Resource data.


# Pokepedia

## Simple app to practice TDD and modular design



## Pokemon List Feature

## Use Cases

### Load Pokemon List From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Pokemon Feed" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates pokemon list from valid data.
5. System delivers pokemon list.

#### Invalid data – error course (sad path):
1. System delivers error.

#### No connectivity – error course (sad path):
1. System delivers error.



### Load Image Data From Remote Use Case

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
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

#!/bin/bash

END_POINT=http://localhost:8000/

# partition key: "No One You Know"
aws dynamodb put-item \
--endpoint ${END_POINT} \
--table-name Music  \
--item \
    '{
        "Artist": {"S": "No One You Know"}, 
        "SongTitle": {"S": "Call Me Today"}, 
        "AlbumTitle": {"S": "Somewhat Famous"}, 
        "Year": {"N": "2015"},
        "Genre": {"S": "Country"},
        "Tags": {"M": 
            {
                "Composers": {"SS": [ "Smith", "Jones", "Davis" ]},
                "LengthInSeconds": {"N": "214"}
            }
        }
    }'

aws dynamodb put-item \
--endpoint ${END_POINT} \
--table-name Music  \
--item \
    '{
        "Artist": {"S": "No One You Know"}, 
        "SongTitle": {"S": "My Dog Spot"}, 
        "AlbumTitle": {"S": "Hey Now"}, 
        "Price": {"N": "1.98"},
        "Genre": {"S": "Country"},
        "CriticRating": {"N": "8.4"}
    }'

aws dynamodb put-item \
--endpoint ${END_POINT} \
--table-name Music  \
--item \
    '{
        "Artist": {"S": "No One You Know"}, 
        "SongTitle": {"S": "Somewhere Down The Road"}, 
        "AlbumTitle": {"S": "Somewhat Famous"}, 
        "Genre": {"S": "Country"},
        "CriticRating": {"N": "8.4"},
        "Year": {"N": "1984"}
    }'

# partition key: "The Acme Band"
aws dynamodb put-item \
--endpoint ${END_POINT} \
--table-name Music  \
--item \
    '{
        "Artist": {"S": "The Acme Band"}, 
        "SongTitle": {"S": "Still In Love"}, 
        "AlbumTitle": {"S": "The Buck Starts Here"}, 
        "Price": {"N": "2.47"},
        "Genre": {"S": "Rock"},
        "PromotionInfo": {"M": 
            {
                "RadioStationsPlaying": {"SS": [ "KHCR", "KBQX", "WTNR", "WJJH"]},
                "TourDates": {
                    "M": {
                        "Seattle": {"S": "20150625"},
                        "Cleveland": {"S": "20150630"}
                    }
                },
                "Rotation": {"S": "Heavy"}
            }
        }
    }'

aws dynamodb put-item \
--endpoint ${END_POINT} \
--table-name Music  \
--item \
    '{
        "Artist": {"S": "The Acme Band"}, 
        "SongTitle": {"S": "Look Out, World"}, 
        "AlbumTitle": {"S": "The Buck Starts Here"}, 
        "Price": {"N": "0.99"},
        "Genre": {"S": "Rock"}
    }'

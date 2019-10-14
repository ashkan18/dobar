import * as React from "react"
import { BorderBox, Sans, Flex, Image } from "@artsy/palette";
import { Link } from "react-router-dom";
import { randomFromList } from "../util"

export interface Props{
  place: any
}


export const PlaceBrick = (props: Props) => {
  const {place} = props
  const [defaultImage, setDefaultImage] = React.useState()
  React.useEffect(() => {
    if (place && place.images && place.images.length > 0) {
      setDefaultImage(randomFromList(place.images))
    }
  }, [place] )
  return (
    <BorderBox>
      <Flex flexDirection="column" justifyContent="space-between">
        <Link to={`/places/${place.id}`}>
          {defaultImage &&
            <Image src={defaultImage.urls.thumb} lazyLoad={true}/>
          }
          <Sans size="4">{place.name}</Sans>
        </Link>
        <Sans size="2">{place.tags.map( h => `#${h}`).join(" ")}</Sans>
      </Flex>
    </BorderBox>
  )
}
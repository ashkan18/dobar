import * as React from "react"
import { BorderBox, Sans, Flex, Image } from "@artsy/palette";
import { Link } from "react-router-dom";

export interface Props{
  place: any
}

export default class PlaceBrick extends React.Component<Props, {}> {
  public render() {
    const {place} = this.props
    return (
      <BorderBox>
        <Flex flexDirection="column" justifyContent="space-between">
          <Link to={`/places/${place.id}`}>
            {place.images[0] && place.images[0].urls &&
              <Image src={place.images[0].urls.thumb} lazyLoad={true}/>
            }
            <Sans size="4">{place.name}</Sans>
          </Link>
          <Sans size="2">{place.tags.map( h => `#${h}`).join(" ")}</Sans>
        </Flex>
      </BorderBox>
    )
  }
}

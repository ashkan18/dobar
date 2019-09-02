import * as React from "react"
import PlaceBrick from "./placeBrick";
import { Flex } from "@artsy/palette";

export interface Props{
  places: Array<any>
}

export default class PlacesWall extends React.Component<Props, {}> {
  public render() {
    return (
    <Flex flexDirection="row" mt={2} flexWrap={"wrap"}>
      {this.props.places.map(p => <PlaceBrick key={p.id} place={p}/>)}
    </Flex>);
  }
}

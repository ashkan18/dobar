import * as React from "react"
import { BorderBox } from "@artsy/palette";
import { Link } from "react-router-dom";

export interface Props{
  place: any
}

export default class PlaceBrick extends React.Component<Props, {}> {
  public render() {
    return (
      <Link to={`/places/${this.props.place.id}`}>
        <BorderBox>
          {this.props.place.name}
        </BorderBox>
      </Link>
    )
  }
}

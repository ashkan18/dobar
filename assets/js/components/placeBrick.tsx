import * as React from "react"

export interface Props{
  place: any
}

export default class PlaceBrick extends React.Component<Props, {}> {
  public render() {
    return (<>
      {this.props.place.name}
    </>);
  }
}

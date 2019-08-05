import * as React from "react"
import { Spinner, Flex, Box, Button, Serif, BorderBox, space, color, Col, Image, Sans } from "@artsy/palette"

import Header from "../components/header";
import { Query } from "react-apollo";
import gql from "graphql-tag";

interface State {
  dobar: boolean
  rideShareDobar: boolean
}
interface Props {
  match: any
}

const FIND_PLACE_QUERY = gql`
  query FindPlace($id: ID!){
    place(id: $id) {
      id
      name
      location
    }
  }
`

export default class PlaceDetail extends React.Component<Props, State>{
  public constructor(props: Props, context: any) {
    super(props, context)
    this.state = { dobar: false, rideShareDobar: false }
  }
  public render(){
    return(
      <Query query={FIND_PLACE_QUERY} variables={{id: this.props.match.params.placeId}}>
        {({ loading, error, data }) => {
          return (
            <>
              <Header noLogin={false}/>
              { loading && <Spinner size="large"/>}
              { error && <> Error! {error} </>}
              { !error && !loading && data &&
                <Flex flexDirection="column" justifyContent="space-between">
                  <Sans size={4}>{data.place.name}</Sans>
                  <Sans size={2}>Would you go to this place again?</Sans>
                  <Button variant="secondaryOutline">Yes</Button>
                  {this.state.dobar &&
                  <>
                    <Sans size={2}>You are 3 miles away from {data.place.name}, would you use a rideshare service to go there?</Sans>
                    <Button disabled={this.state.dobar && !this.state.rideShareDobar} variant="secondaryOutline">Yes</Button>
                  </>
                  }
                </Flex>
              }
            </>
          )
        }}
      </Query>
    )
  }
}

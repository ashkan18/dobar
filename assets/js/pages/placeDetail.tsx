import * as React from "react"
import { Spinner, Flex, Sans, CheckIcon, CloseIcon } from "@artsy/palette"

import Header from "../components/header";
import { Query } from "react-apollo";
import gql from "graphql-tag";

interface State {
  haveBeenToPlace: boolean | null
  dobar: boolean | null
  rideShareDobar: boolean | null
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
    this.state = { haveBeenToPlace: null, dobar: null, rideShareDobar: null }
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
                  <Flex flexDirection="row">
                    <Sans size={2}>Have you been to {data.place.name}?</Sans>
                    <CheckIcon ml={2} opacity={this.state.haveBeenToPlace === true ? 1 : 0.2} onClick={ _e => this.setState({haveBeenToPlace: true})}/>
                  </Flex>
                  {this.state.haveBeenToPlace &&
                    <Flex flexDirection="row">
                      <Sans size={2}>Would you go to this place again?</Sans>
                      <CheckIcon ml={2} opacity={this.state.dobar === true ? 1 : 0.2} onClick={ _e => this.setState({dobar: true})}/>
                      <CloseIcon ml={2} opacity={this.state.dobar === false ? 1 : 0.2} onClick={ _e => this.setState({dobar: false})}/>
                    </Flex>
                  }
                  {this.state.dobar &&
                    <Flex flexDirection="row">
                      <Sans size={2}>You are 3 miles away from {data.place.name}, would you use a rideshare service to go there?</Sans>
                      <CheckIcon ml={2} opacity={this.state.rideShareDobar === true ? 1 : 0.2} onClick={ _e => this.setState({rideShareDobar: true})}/>
                      <CloseIcon ml={2} opacity={this.state.rideShareDobar === false ? 1 : 0.2} onClick={ _e => this.setState({rideShareDobar: false})}/>
                    </Flex>
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

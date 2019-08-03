import * as React from "react"
import { Flex, Input, Button, Spinner } from "@artsy/palette"
import Header from "../components/header";
import gql from "graphql-tag";
import { ApolloConsumer } from "react-apollo";
import PlaceBrick from "../components/placeBrick";
import PlacesWall from "../components/placesWall";

const FIND_PLACES = gql`
  query findPlaces($location: LocationInput, $term: String) {
    places(first: 10, location: $location, term: $term){
      edges{
        node{
          id
          name
        }
      }
    }
  }
`
interface State {
  places: Array<any>
  loading: boolean
}

export default class Home extends React.Component<{}, State>{
  public constructor(props: {}, context: any) {
    super(props, context)
    this.state = {places: [], loading: false}
  }

  public render(){
    return(
      <Flex flexDirection="column" justifyItems="normal">
        <Header noLogin={false}/>
        <Flex flexDirection="row" mt={0}>
          <Input placeholder="Where"/>
          <Input placeholder="What"/>
          <ApolloConsumer>
            { client => (
              <Button onClick={ _e => {
                client.query({
                  query: FIND_PLACES,
                  variables: { location: {lat: 73, lng: 34}}
                }).then(({data, loading}) => {
                  if (loading) {
                    this.setState({loading})
                  } else {
                    this.setState({places: data.places.edges.map( e => e.node)})
                  }
                })
              }}
              > Search </Button>
            )}
          </ApolloConsumer>
        </Flex>
        {this.state.loading && <Spinner />}
        {this.state.places && <PlacesWall places={this.state.places.map( p => p)} />}
      </Flex>
    )
  }
}

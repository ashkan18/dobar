import * as React from "react"
import { Flex, Input, Button, Spinner } from "@artsy/palette"
import Header from "../components/header";
import gql from "graphql-tag";
import { ApolloConsumer } from "react-apollo";
import PlaceBrick from "../components/placeBrick";

const FIND_PLACES = gql`
  query findPlaces($location: LocationInput, $term: String) {
    places(first: 10, location: $location, term: $term){
      edges{
        node{
          id
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
      <>
        <Header noLogin={false}/>
        <Flex flexDirection="row">
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
          {this.state.loading && <Spinner />}
          {this.state.places && this.state.places.map( p => {
            return(
              <PlaceBrick place={p}/>
            )
          })
          }
        </Flex>
      </>
    )
  }
}

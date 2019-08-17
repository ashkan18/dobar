import * as React from "react"
import { Flex, Input, Button, Spinner } from "@artsy/palette"
import Header from "../components/header";
import gql from "graphql-tag";
import PlacesWall from "../components/placesWall";
import { useState } from "react";
import { useLazyQuery } from "@apollo/react-hooks";

const FIND_PLACES = gql`
  query findPlaces($location: LocationInput, $term: String) {
    places(first: 10, location: $location, term: $term){
      edges{
        node{
          id
          name
          workingHours
          tags
          images {
            urls {
              original
              thumb
            }
          }
        }
      }
    }
  }
`
export const Search = () => {
  const [what, setWhat] = useState(null)
  const [where, setWhere] = useState({lat: 73, lng: 34})
  const [search, { called, loading, error, data }] = useLazyQuery(FIND_PLACES)
  return (
    <Flex flexDirection="column">
      <Header noLogin={false}/>
      <Flex flexDirection="row" mt={0}>
        <Input placeholder="Where" />
        <Input placeholder="What" onChange={e => setWhat(e.currentTarget.value)}/>
        <Button onClick={ _e => search({variables: { location: where, term: what}})}>Search</Button>
      </Flex>
      { loading && <Spinner/>}
      { called && !loading && data && <PlacesWall places={data.places.edges.map( e => e.node)}/>}
    </Flex>
  )
}

import * as React from "react"
import { Flex, Input, Button, Spinner } from "@artsy/palette"
import Header from "../components/header";
import gql from "graphql-tag";
import PlacesWall from "../components/placesWall";
import { useState, useEffect } from "react";
import { useLazyQuery } from "@apollo/react-hooks";
import { usePosition } from "../usePosition";

interface Props {
  location: any
}

const FIND_PLACES = gql`
  query findPlaces($location: LocationInput, $address: String, $term: String) {
    places(first: 100, location: $location, address: $address, term: $term){
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
export const Search = (props: Props) => {
  const { location } = props
  const params = new URLSearchParams(location.search);
  const [what, setWhat] = useState(params.get("term"))
  const [where, setWhere] = useState({lat: 40.7188725, lng: -74.0047466})
  const [address, setAddress] = useState()
  const [search, { called, loading, error: queryError, data }] = useLazyQuery(FIND_PLACES)
  const {position, error: positionError} = usePosition()
  const onSubmit = (e) => {
    e.preventDefault()
    search({variables: { location: where, term: what, address: address}})
  }
  useEffect(() => {
    if (position && !called) {
      const {coords} = position
      setWhere({lat: coords.latitude, lng: coords.longitude})
      search({variables: { location: where, term: what, address}})
    }
  }, [position])
  useEffect(() => {
    document.title = `Dobar . Home`
  }, [])
  return (
    <Flex flexDirection="column">
      <Header noLogin={false}/>
        <form onSubmit={onSubmit}>
          <Flex flexDirection="row" mt={0}>
            <Input placeholder="Where" onChange={ e => setAddress(e.currentTarget.value) } value={address || ""} />
            <Input placeholder="What" onChange={e => setWhat(e.currentTarget.value) } value={what || ""}/>
            <Button>Search</Button>
          </Flex>
        </form>
      { loading && <Spinner/>}
      { called && !loading && data && <PlacesWall places={data.places.edges.map( e => e.node)}/>}
    </Flex>
  )
}

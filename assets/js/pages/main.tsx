import * as React from "react"
import { Flex, Input, Button, Spinner, MagnifyingGlassIcon, LocationIcon } from "@artsy/palette"
import Header from "../components/header";
import gql from "graphql-tag";
import PlacesWall from "../components/placesWall";
import { useState, useEffect } from "react";
import { useLazyQuery, useQuery } from "@apollo/react-hooks";
import { usePosition } from "../usePosition";
import { FeaturedPlaces } from "../components/featuredPlaces";

interface Props {
  location: any
}

const POPULAR_PLACES = gql`
query featuredPlaces {
  popular: places(first: 3, order: "popularity"){
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
  random: places(first: 3, order: "random"){
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
export const Main = (props: Props) => {
  const { location } = props
  const params = new URLSearchParams(location.search);
  const {loading: popularLoading, data: featuredData} = useQuery(POPULAR_PLACES)
  const [what, setWhat] = useState(params.get("term"))
  const [where, setWhere] = useState()
  const [address, setAddress] = useState()
  const [search, { called, loading, error: queryError, data }] = useLazyQuery(FIND_PLACES)
  const {position, error: positionError} = usePosition()
  const [featuredPlaces, setFeaturedPlaces] = useState()
  const onSubmit = (e) => {
    e.preventDefault()
    search({variables: { location: where, term: what, address: address}})
  }
  useEffect(() => {
    if (position && !called) {
      const {coords} = position
      const location = {lat: coords.latitude, lng: coords.longitude}
      setWhere(location)
    }
  }, [position])

  useEffect(() => {
    document.title = `Dobar . Home`
  }, [])

  useEffect(() => {
    if (featuredData) {
      const popular = featuredData.popular.edges.map( e => e.node)
      const random = featuredData.random.edges.map( e => e.node)
      setFeaturedPlaces({popular, random})
    }
   } , [featuredData])

  return (
    <Flex flexDirection="column">
      <Header noLogin={false}/>
      <form onSubmit={onSubmit} style={{maxWidth: "500px", margin: "auto"}}>
        <Flex flexDirection="row" mt={0}>
          { where && <LocationIcon width={40} height={40} mr={1}/>}
          <Input placeholder="Where" onChange={ e => setAddress(e.currentTarget.value) } value={address || ""} />
          <Input placeholder="Restaurant/Cuisine..." onChange={e => setWhat(e.currentTarget.value) } value={what || ""}/>
          <Button><MagnifyingGlassIcon fill={"white100"}/></Button>
        </Flex>
      </form>
      { (popularLoading || loading) && <Spinner/>}
      { featuredPlaces && !data &&
        <Flex flexDirection="row" m="auto" wrap>
          <FeaturedPlaces places={featuredPlaces.popular} feature="Most Popular"/>
          <FeaturedPlaces places={featuredPlaces.random} feature="Lucky Places"/>
        </Flex>
      }
      { called && !loading && data && <PlacesWall places={data.places.edges.map( e => e.node)}/>}
    </Flex>
  )
}

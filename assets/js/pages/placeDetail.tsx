import * as React from "react"
import { Spinner, Flex, Sans, BorderBox, Serif, LocationIcon } from "@artsy/palette"

import Header from "../components/header"
import gql from "graphql-tag"
import { useQuery } from "@apollo/react-hooks"
import { Questions } from "../components/questions"
import { Link } from "react-router-dom";
import { PhotoUpload } from "../components/photoUpload"
import { PlaceImages } from "../components/placeImages"
import { SocialActions } from "../components/socialActions"
interface Props {
  match: any
}

const FIND_PLACE_QUERY = gql`
  query FindPlace($id: ID!){
    place(id: $id) {
      id
      name
      location
      address
      address2
      city
      tags
      images {
        urls {
          thumb
          original
        }
      }
      stats {
        type
        response
        total
      }
      myReview {
        reviewType
        response
      }
      myLists {
        listType
      }
    }
  }
`

const ME_QUERY = gql`
  query {
    me {
      name
    }
  }
`

const aggregateStats = (stats) => {
  return stats.reduce((acc, s) => {
    acc[s.type][s.response ? 'yes' : 'no'] = s.total
    return acc
  }, {"dobar": {"yes": 0, "no": 0}, "rideshare_dobar": {"yes": 0, "no": 0}})
}

export const PlaceDetail = (props: Props) => {
  const {loading, data} = useQuery(FIND_PLACE_QUERY, {variables: {id: props.match.params.placeId}})
  const {loading: meLoading, data: meData} = useQuery(ME_QUERY)
  const tagsDisplay = (tags: Array<string>) => {
    return(
      <Flex flexDirection="row">
        {tags.map(t => <Link to={{pathname: "/", search: `?term=${t}`}}><Sans size={3} mr={0.5}>#{t}</Sans></Link>)}
      </Flex>
    )
  }

  if (loading) {
    return(
      <Flex flexDirection="column">
        <Header noLogin={false}/>
        <Spinner size="large"/>
      </Flex>
    )
  } else if (data.place) {
    const { place } =  data
    const stats = aggregateStats(place.stats)
    return(
      <Flex flexDirection="column">
        <Header noLogin={false}/>
        <Flex flexDirection="column" justifyContent="space-between" m="auto" style={ { minWidth: "600px" }}>
          <Sans size={10}>{place.name}</Sans>
          {place.tags && tagsDisplay(place.tags)}
          <PlaceImages images={place.images}/>
          { meData && meData.me && place &&
            <PhotoUpload me={meData.me} place={place}/>
          }
          <SocialActions place={place}/>
          <Flex flexDirection="row" justifyContent="space-between" m="auto" mt={1} mb={2}>
            <LocationIcon/>
            <Serif size={4}>{[place.address, place.address2, place.city].filter(Boolean).join(", ")}</Serif>
          </Flex>
          {stats.dobar &&
            <BorderBox mt={2}>
              <Flex flexDirection="column">
                <Serif size={3}>Number Of total check-ins: <strong>{stats["dobar"]["yes"] + stats["dobar"]["no"]}</strong></Serif>
                <Serif size={3}>Would go back: <strong>{stats["dobar"]["yes"]}</strong> and not go back <strong>{stats["dobar"]["no"]}</strong></Serif>
                <Serif size={3}>Would even pay for rideshare to go back: <strong>{stats["rideshare_dobar"]['yes'] }</strong> and not go back <strong>{ stats["rideshare_dobar"]["no"] || 0 }</strong></Serif>
              </Flex>
            </BorderBox>
          }
          <Questions place={place} user={meData.me} />
        </Flex>
      </Flex>
    )
  }
}

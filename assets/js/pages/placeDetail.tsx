import * as React from "react"
import { Spinner, Flex, Sans, Image, BorderBox, Modal, HeartFillIcon, MessageIcon, Box, Serif, LocationIcon, Button, Input } from "@artsy/palette"

import Header from "../components/header"
import gql from "graphql-tag"
import { useQuery, useMutation } from "@apollo/react-hooks"
import { Questions } from "../components/questions"
import { Link } from "react-router-dom";
import { useState } from "react";
import { PlaceInvite } from "../components/placeInvite";
import { PhotoUpload } from "../components/photoUpload";


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


const ADD_TO_LIST_MUTATION = gql`
  mutation AddToList($placeId: ID!, $listType: String!){
    addToList(placeId: $placeId, listType: $listType){
      id
    }
  }
`

const UPLOAD_PHOTO_MUTATION = gql`
  mutation UploadPlacePhoto($placeId: ID!, $photo: Upload!){
    uploadPlacePhoto(placeId: $placeId, photo: $photo){
      id
    }
  }
`
const aggregateStats = (stats) => {
  return stats.reduce((acc, s) => {
    if (!acc[s.type]){
      acc[s.type] = {}
    }
    acc[s.type][s.response] = s.total
    return acc
  }, {})
}

export const PlaceDetail = (props: Props) => {
  const [showInvites, setShowInvites] = useState(false)
  const {loading, data} = useQuery(FIND_PLACE_QUERY, {variables: {id: props.match.params.placeId}})
  const [addToListMutation, { loading: addToListLoading, error: addToListError }] = useMutation(ADD_TO_LIST_MUTATION)
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
        <Flex flexDirection="column" justifyContent="space-between" m="auto">
          <Sans size={10}>{place.name}</Sans>
          {place.tags && tagsDisplay(place.tags)}
          {place.images[0] && place.images[0].urls &&
            <Image src={place.images[0].urls.original} style={{maxHeight: 500}}/>
          }
          { meData && meData.me && place &&
            <PhotoUpload me={meData.me} place={place} />
          }
          <Flex flexDirection="row" justifyContent="space-between" m="auto" mt={1} mb={2}>
            <HeartFillIcon width={30} height={30} style={{cursor: "copy"}} onClick={(e) => addToListMutation({variables: {placeId: place.id, listType: "planning_to_go"}})} />
            <MessageIcon width={30} height={30} style={{cursor: "pointer"}} onClick={ _e => setShowInvites(true) }/>
          </Flex>
          <Flex flexDirection="row" justifyContent="space-between" m="auto" mt={1} mb={2}>
            <LocationIcon/>
            <Serif size={4}>{[place.address, place.address2, place.city].filter(Boolean).join(", ")}</Serif>
          </Flex>
          {stats.dobar &&
            <BorderBox mt={2}>
              <Flex flexDirection="column">
                <Serif size={3}>Number Of total check-ins: <strong>{(stats["dobar"][true] || 0 )+ (stats["dobar"][false] || 0)}</strong></Serif>
                <Serif size={3}>Would go back: <strong>{stats["dobar"][true] }</strong> and not go back <strong>{ stats["dobar"][false] || 0 }</strong></Serif>
                <Serif size={3}>Would even pay for rideshare to go back: <strong>{stats["rideshare_dobar"][true] }</strong> and not go back <strong>{ stats["rideshare_dobar"][false] || 0 }</strong></Serif>
              </Flex>
            </BorderBox>
          }
          <Questions place={place} user={meData.me} />
          <Modal
              title="Plan a visit"
              hasLogo={false}
              isWide
              show={showInvites}
              onClose={() => setShowInvites(false)}
            >
              <PlaceInvite place={place}/>
          </Modal>
        </Flex>
      </Flex>
    )
  }
}

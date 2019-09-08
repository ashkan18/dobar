import * as React from "react"
import { Spinner, Flex, Sans, Image, BorderBox, Modal, HeartFillIcon, MessageIcon } from "@artsy/palette"

import Header from "../components/header"
import gql from "graphql-tag"
import { useQuery, useMutation } from "@apollo/react-hooks"
import { Questions } from "../components/questions"
import { Link } from "react-router-dom";
import { useState } from "react";
import { PlaceInvite } from "../components/placeInvite";


interface Props {
  match: any
}

const FIND_PLACE_QUERY = gql`
  query FindPlace($id: ID!){
    place(id: $id) {
      id
      name
      location
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

const ADD_TO_LIST_MUTATION = gql`
  mutation AddToList($placeId: ID!, $listType: String!){
    addToList(placeId: $placeId, listType: $listType){
      id
    }
  }
`

const labelForStatType = (type: string) => {
  switch(type) {
    case "dobar":
      return "✌️  "
    case "rideshare_dobar":
      return "🚕✌️"
  }
}

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
  const { loading, data } = useQuery(FIND_PLACE_QUERY, {variables: {id: props.match.params.placeId}})
  const [addToListMutation, { loading: addToListLoading, error: addToListError }] = useMutation(ADD_TO_LIST_MUTATION)
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
          <Flex flexDirection="row" justifyContent="space-between" m="auto" mt={1} mb={3}>
            <HeartFillIcon width={30} height={30} style={{cursor: "copy"}} onClick={(e) => addToListMutation({variables: {placeId: place.id, listType: "planning_to_go"}})} />
            <MessageIcon width={30} height={30} style={{cursor: "pointer"}} onClick={ _e => setShowInvites(true) }/>
          </Flex>
          {stats.dobar &&
            <BorderBox>
              <Flex flexDirection="column">
                {Object.keys(stats).map(type =>
                  <Sans size={3}>
                    {labelForStatType(type)}: 👍 {stats[type][true]} 👎 {stats[type][false]}
                  </Sans>
                )}
              </Flex>
            </BorderBox>
          }
          <Questions place={place}/>
          <Modal
              title="Invite friends to"
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

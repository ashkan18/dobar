import * as React from "react"
import { Spinner, Flex, Sans, Image, Icon, MapPinIcon, BorderBox } from "@artsy/palette"

import Header from "../components/header"
import gql from "graphql-tag"
import { useQuery, useMutation } from "@apollo/react-hooks"
import { Questions } from "../components/questions"

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

const labelForStatType = (type) => {
  switch(type) {
    case "dobar":
      return "Dobar"
    case "rideshare_dobar":
      return "Rideshare"
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
  const { loading, data } = useQuery(FIND_PLACE_QUERY, {variables: {id: props.match.params.placeId}})
  let stats = null
  if (data.place !== undefined) {
    stats = aggregateStats(data.place.stats)
  }
  const [addToListMutation, { loading: addToListLoading, error: addToListError }] = useMutation(ADD_TO_LIST_MUTATION)
  if (loading) {
    return(
      <Flex flexDirection="column">
        <Header noLogin={false}/>
        <Spinner size="large"/>
      </Flex>
    )
  } else if (data) {
    return(
      <Flex flexDirection="column">
        <Header noLogin={false}/>
        <Flex flexDirection="column" justifyContent="space-between" m="auto">
          <Sans size={10}>{data.place.name}</Sans>
          <Sans size={3}>{data.place.tags.map(t => `#${t}`).join(" ")}</Sans>
          <Image src={data.place.images[0].urls.original}/>
          <Flex flexDirection="row" justifyContent="space-between" m="auto" mt={1} mb={3}>
            <MapPinIcon width={25} height={25} style={{cursor: "copy"}} onClick={(e) => addToListMutation({variables: {placeId: data.place.id, listType: "planning_to_go"}})} />
          </Flex>
          <BorderBox>
            <Flex flexDirection="column">
              {stats && Object.keys(stats).map(type =>
                <Sans size={3}>
                  {labelForStatType(type)}: {stats[type][true]} - {stats[type][false]}
                </Sans>
              )}
            </Flex>
          </BorderBox>
          <Questions place={data.place}/>
        </Flex>
      </Flex>
    )
  }
}

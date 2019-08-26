import * as React from "react"
import { Flex, Spinner, Sans, Separator } from "@artsy/palette"
import Header from "../components/header";
import gql from "graphql-tag";
import PlacesWall from "../components/placesWall";
import { useQuery } from "@apollo/react-hooks";
import PlaceBrick from "../components/placeBrick";

const MY_LIST = gql`
  query Me {
      me{
        name
        lists(first: 10){
          edges{
            node{
              listType
              place {
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
              }
            }
          }
        }
        invites(first: 50) {
          edges {
            node {
              id
              status
              guestEmail
              place {
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
              }
            }
          }
        }
      }
    }
`

interface InvitationProps {
  invitation: any
}

export const Invitation = (props: InvitationProps) => {
  const {invitation} = props
  return(
    <Flex flexDirection="column" mt={2}>
      <Sans size={2}>{invitation.guestEmail} - {invitation.status}</Sans>
      <PlaceBrick place={invitation.place} />
    </Flex>
  )
}
export const Me = () => {
  const { loading, data } = useQuery(MY_LIST)
  return (
    <Flex flexDirection="column">
      <Header noLogin={false}/>
      { loading && <Spinner/>}
      { !loading && data &&
        <>
          <Sans size={5}>My List</Sans>
          <Separator width={70}/>
          <PlacesWall places={data.me.lists.edges.map(l => l.node.place)}/>
          <Sans size={5}>My Invites</Sans>
          <Separator width={70}/>
          {data.me.invites.edges.map(i => <Invitation invitation={i.node}/>)}
        </>
      }
    </Flex>
  )
}

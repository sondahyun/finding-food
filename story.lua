-----------------------------------------------------------------------------------------
--
-- story.lua
-- 통합 스토리 씬 - params를 받아 JSON 대사/배경/음악을 동적으로 로드
--
-- 사용법:
--   composer.gotoScene("story", {
--       params = {
--           jsonFile     = "Content/JSON/story01.json",
--           initBg       = "Content/PNG/script/background/시골3.png",
--           music        = "Content/PNG/script/다시그곳으로.mp3",
--           endingImg    = "Content/PNG/stage/장소이동.png",
--           nextScene    = "stage02",
--           setVariable  = { key = "fishcheck", value = 1 },  -- (선택)
--       }
--   })
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local scene = composer.newScene()
local loadsave = require("loadsave")
local json = require("json")

local Data       -- JSON 대사 데이터
local bgMusic    -- 현재 재생 중인 음악 핸들

-- JSON 파일 파싱
local function parseJSON(jsonFile)
    local filename = system.pathForFile(jsonFile)
    local data, pos, msg = json.decodeFile(filename)

    if data then
        return data
    else
        print("JSON parse error: " .. tostring(pos))
        print("Message: " .. tostring(msg))
        return nil
    end
end

function scene:create(event)
    local sceneGroup = self.view
    local params = event.params or {}

    -- params에서 설정 읽기
    local jsonFile    = params.jsonFile    or "Content/JSON/story01.json"
    local initBg      = params.initBg      or "Content/PNG/script/background/시골3.png"
    local musicFile   = params.music       or "Content/PNG/script/다시그곳으로.mp3"
    local endingImg   = params.endingImg   or "Content/PNG/stage/장소이동.png"
    local nextScene   = params.nextScene   or "stage01"
    local setVariable = params.setVariable  -- { key = "...", value = ... } 또는 nil

    -- JSON 파싱
    Data = parseJSON(jsonFile)

    -- 세이브 로드
    local loadedEnding = loadsave.loadTable("ending.json")

    -- 배경
    local background = display.newImageRect(initBg, display.contentWidth, display.contentHeight)
    background.x, background.y = display.contentWidth / 2, display.contentHeight / 2

    -- 대사창
    local section = display.newRect(display.contentWidth / 2, display.contentHeight * 0.8, display.contentWidth, display.contentHeight * 0.3)
    section:setFillColor(0.8, 0.8, 0.8, 0.8)

    -- 캐릭터 이미지
    local speakerImg = display.newRect(section.x, section.y - 700, 900, 900)

    -- 화자 이름
    local speaker = display.newText("", section.x - 350, section.y - 75)
    speaker.width = display.contentWidth
    speaker.size = 70
    speaker:setFillColor(0)

    -- 대사 텍스트
    local script = display.newText("", section.x, section.y + 30, display.contentWidth * 0.85, 120)
    script.size = 50
    script:setFillColor(0)

    -- 스토리 종료 후 버튼 (처음엔 숨김)
    local ending = display.newImage(endingImg)
    ending.alpha = 0
    ending.x, ending.y = display.contentWidth * 0.5, display.contentHeight / 2 - 600

    -- 볼륨 설정 오버레이
    local options = { isModal = true }

    local volumeButton = display.newImage("Content/PNG/설정/설정.png")
    volumeButton.x, volumeButton.y = display.contentWidth * 0.87, display.contentHeight - 1800
    sceneGroup:insert(volumeButton)

    local function setVolume()
        composer.showOverlay("volumeControl", options)
    end
    volumeButton:addEventListener("tap", setVolume)

    -- 음악 재생
    bgMusic = audio.loadStream(musicFile)
    if loadedEnding and loadedEnding.logValue then
        audio.setVolume(loadedEnding.logValue)
    end
    audio.play(bgMusic)

    -- 대사 진행 로직
    local index = 1

    local function nextScript()
        if not Data then return end

        if index <= #Data then
            local entry = Data[index]

            if entry.type == "background" then
                -- 배경 교체
                background.fill = {
                    type = "image",
                    filename = entry.img
                }
                index = index + 1
                nextScript()  -- 배경은 자동으로 넘김

            elseif entry.type == "Narration" then
                -- 해설 (캐릭터 이미지 숨김)
                speakerImg.alpha = 0
                speaker.alpha = 0
                script.text = entry.content
                index = index + 1

            elseif entry.type == "Dialogue" then
                -- 대사
                speakerImg.alpha = 1
                speakerImg.fill = {
                    type = "image",
                    filename = entry.img
                }
                speaker.alpha = 1
                speaker.text = entry.speaker
                script.text = entry.content
                index = index + 1
            end
        else
            -- 모든 대사 종료 → ending 버튼 표시
            ending.alpha = 1
        end
    end

    -- 첫 대사 표시
    nextScript()

    -- 대사창 탭 → 다음 대사
    local function onSectionTap()
        nextScript()
    end

    -- 종료 버튼 탭 → 다음 씬으로 이동
    local function onEndingTap()
        audio.pause(bgMusic)
        if setVariable then
            composer.setVariable(setVariable.key, setVariable.value)
        end
        composer.removeScene("story")
        composer.gotoScene(nextScene)
    end

    section:addEventListener("tap", onSectionTap)
    ending:addEventListener("tap", onEndingTap)

    -- 레이어 정리
    sceneGroup:insert(background)
    sceneGroup:insert(section)
    sceneGroup:insert(speakerImg)
    sceneGroup:insert(speaker)
    sceneGroup:insert(script)
    sceneGroup:insert(ending)
    sceneGroup:insert(volumeButton)
end

function scene:show(event)
    local phase = event.phase
    if phase == "will" then
    elseif phase == "did" then
    end
end

function scene:hide(event)
    local phase = event.phase
    if phase == "will" then
    elseif phase == "did" then
        -- 씬 나갈 때 음악 정리
        if bgMusic then
            audio.stop()
            audio.dispose(bgMusic)
            bgMusic = nil
        end
    end
end

function scene:destroy(event)
    Data = nil
end

---------------------------------------------------------------------------------

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene

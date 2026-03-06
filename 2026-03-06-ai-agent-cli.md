# AI 에이전트를 위해선 CLI를 다시 작성해야 합니다

URL: https://news.hada.io/topic?id=27246
Date: 2026-03-06

## 요약

사람 중심 CLI와 AI 에이전트 중심 CLI는 설계 목표가 근본적으로 다르며, 기존 CLI를 에이전트용으로 개조하는 것은 비효율적입니다.

### 핵심 차이
- Human DX: 발견 가능성(discoverability)과 관용(forgiveness) 최적화
- Agent DX: 예측 가능성(predictability)과 다층 방어(defense-in-depth) 최적화

### Agent-First CLI 패턴

1. **Raw JSON 페이로드 > 개별 플래그**
   - `--json` 하나로 API 스키마에 직접 매핑되는 전체 페이로드 전달
   - LLM이 생성하기 쉬움, 중첩 구조 표현 가능

2. **스키마 인트로스펙션**
   - `gws schema ...`로 런타임에서 CLI의 수용 범위 조회
   - 정적 문서 대신 CLI 자체가 기계 판독 가능한 진실 공급원

3. **컨텍스트 윈도우 관리**
   - Field masks: `--params '{"fields": "files(id,name)"}'`로 반환 범위 제한
   - NDJSON 페이지네이션: 스트림으로 점진적 처리

4. **할루시네이션 대응 입력 경화**
   - 모든 경로: CWD 내 샌드박싱
   - 제어 문자: ASCII 0x20 미만 거부
   - 리소스 ID: `?`, `#` 차단
   - URL 인코딩: `%` 포함 시 거부

5. **에이전트 스킬 제공**
   - 100개 이상의 SKILL.md 파일로 --help로 알 수 없는 가이드 인코딩
   - "항상 --dry-run 사용", "쓰기 전 확인", "list에 --fields 추가" 등

6. **멀티 서피스 지원**
   - MCP: stdio 위의 JSON-RPC 도구로 노출
   - Gemini Extensions: 에이전트의 네이티브 기능으로 설치
   - 헤드리스 환경 변수: 브라우저 없이 인증

7. **안전 장치**
   - `--dry-run`: API 호출 전 로컬 검증
   - `--sanitize`: Model Armor로 응답 정제 (프롬프트 인젝션 방지)

### 기존 CLI 개선 순서
1. `--output json` 추가
2. 모든 입력 검증
3. 스키마/`--describe` 명령 추가
4. 필드 마스크/`--fields` 지원
5. `--dry-run` 추가
6. CONTEXT.md/스킬 파일 배포
7. MCP 서피스 노출
